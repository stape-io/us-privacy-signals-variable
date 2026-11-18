const createRegex = require('createRegex');
const decodeUriComponent = require('decodeUriComponent');
const getAllEventData = require('getAllEventData');
const getCookieValues = require('getCookieValues');
const getRequestHeader = require('getRequestHeader');
const getType = require('getType');
const makeInteger = require('makeInteger');
const makeString = require('makeString');
const Math = require('Math');
const testRegex = require('testRegex');

/*==============================================================================
==============================================================================*/

const OPT_OUT = 'opt_out';
const NO_OPT_OUT = 'no_opt_out';
const UNKNOWN = 'unknown';
const DISABLED = 'disabled';
const SIGNAL_NAMES = ['gpc', 'gpp', 'us_privacy', 'cmp', 'consent_mode'];
const MAX_GPP_SECTION_ID = 1000;
const TRUSTARC_NOT_PROVISIONED = '100';

const GPP_SECTIONS = {
  6: { name: 'uspv1' },
  7: {
    name: 'usnat',
    versions: [1, 2],
    fields: [
      { name: 'sale', offset: 18 },
      { name: 'sharing', offset: 20 },
      { name: 'targeted_advertising', offset: 22 }
    ],
    hasGpcSegment: true
  },
  8: {
    name: 'usca',
    versions: [1],
    fields: [
      { name: 'sale', offset: 12 },
      { name: 'sharing', offset: 14 }
    ],
    hasGpcSegment: true
  },
  9: {
    name: 'usva',
    versions: [1],
    fields: [
      { name: 'sale', offset: 12 },
      { name: 'targeted_advertising', offset: 14 }
    ],
    hasGpcSegment: false
  },
  10: {
    name: 'usco',
    versions: [1],
    fields: [
      { name: 'sale', offset: 12 },
      { name: 'targeted_advertising', offset: 14 }
    ],
    hasGpcSegment: true
  },
  11: {
    name: 'usut',
    versions: [1],
    fields: [
      { name: 'sale', offset: 14 },
      { name: 'targeted_advertising', offset: 16 }
    ],
    hasGpcSegment: false
  },
  12: {
    name: 'usct',
    versions: [1],
    fields: [
      { name: 'sale', offset: 12 },
      { name: 'targeted_advertising', offset: 14 }
    ],
    hasGpcSegment: true
  }
};

const US_STATE_CODES = {
  alabama: 'AL',
  alaska: 'AK',
  arizona: 'AZ',
  arkansas: 'AR',
  california: 'CA',
  colorado: 'CO',
  connecticut: 'CT',
  delaware: 'DE',
  'district of columbia': 'DC',
  florida: 'FL',
  georgia: 'GA',
  hawaii: 'HI',
  idaho: 'ID',
  illinois: 'IL',
  indiana: 'IN',
  iowa: 'IA',
  kansas: 'KS',
  kentucky: 'KY',
  louisiana: 'LA',
  maine: 'ME',
  maryland: 'MD',
  massachusetts: 'MA',
  michigan: 'MI',
  minnesota: 'MN',
  mississippi: 'MS',
  missouri: 'MO',
  montana: 'MT',
  nebraska: 'NE',
  nevada: 'NV',
  'new hampshire': 'NH',
  'new jersey': 'NJ',
  'new mexico': 'NM',
  'new york': 'NY',
  'north carolina': 'NC',
  'north dakota': 'ND',
  ohio: 'OH',
  oklahoma: 'OK',
  oregon: 'OR',
  pennsylvania: 'PA',
  'rhode island': 'RI',
  'south carolina': 'SC',
  'south dakota': 'SD',
  tennessee: 'TN',
  texas: 'TX',
  utah: 'UT',
  vermont: 'VT',
  virginia: 'VA',
  washington: 'WA',
  'west virginia': 'WV',
  wisconsin: 'WI',
  wyoming: 'WY'
};

const eventData = getAllEventData() || {};

const geo = getGeo(data, eventData);
const applies = isRegionApplicable(data, geo);

const signalResults = {
  gpc: isUIFieldTrue(data.enableGpc) ? evaluateGpc() : { status: DISABLED },
  gpp: isUIFieldTrue(data.enableGpp) ? evaluateGpp(data, eventData) : { status: DISABLED },
  us_privacy: isUIFieldTrue(data.enableUsPrivacy)
    ? evaluateUsPrivacy(data, eventData)
    : { status: DISABLED },
  cmp: isUIFieldTrue(data.enableCmp) ? evaluateCmp(data) : { status: DISABLED },
  consent_mode: isUIFieldTrue(data.enableConsentMode)
    ? evaluateConsentMode(data, eventData)
    : { status: DISABLED }
};

const resolution = resolveSignals(data, signalResults);
const result = buildResult(data, geo, applies, resolution, signalResults);

return getReturnValue(data, result);

/*==============================================================================
  Signal evaluation
==============================================================================*/

function evaluateGpc() {
  const header = getRequestHeader('sec-gpc');
  if (!isValidValue(header)) return { status: UNKNOWN };
  const value = makeString(header).split(',')[0].trim();
  return { status: value === '1' ? OPT_OUT : UNKNOWN, value: value };
}

function evaluateUsPrivacy(data, eventData) {
  const source = getFirstValid([
    [data.usPrivacyString, 'variable'],
    [getSystemProperty(eventData, 'us_privacy'), 'x-sst-system_properties.us_privacy'],
    [eventData['x-ads-us_privacy'], 'x-ads-us_privacy'],
    [getCookieValues('usprivacy')[0], 'cookie_usprivacy'],
    [getCookieValues('us_privacy')[0], 'cookie_us_privacy']
  ]);
  if (!source) return { status: UNKNOWN };
  return {
    status: parseUsPrivacyString(source.value),
    value: makeString(source.value),
    source: source.source
  };
}

function evaluateGpp(data, eventData) {
  const gppSource = getFirstValid([
    [data.gppString, 'variable'],
    [getSystemProperty(eventData, 'gpp'), 'x-sst-system_properties.gpp'],
    [eventData['x-ads-gpp'], 'x-ads-gpp'],
    [getCookieValues('OTGPPConsent')[0], 'cookie_OTGPPConsent']
  ]);
  if (!gppSource) return { status: UNKNOWN };

  const sidSource = getFirstValid([
    [data.gppSid, 'variable'],
    [getSystemProperty(eventData, 'gpp_sid'), 'x-sst-system_properties.gpp_sid'],
    [eventData['x-ads-gpp_sid'], 'x-ads-gpp_sid']
  ]);
  const applicableSids = sidSource ? parseSidList(sidSource.value) : undefined;

  const decoded = decodeGppString(makeString(gppSource.value));
  if (!decoded) {
    return {
      status: UNKNOWN,
      value: makeString(gppSource.value),
      source: gppSource.source,
      error: 'invalid_gpp_string'
    };
  }

  const considered = decoded.filter((section) => {
    return !applicableSids || applicableSids.indexOf(section.id) !== -1;
  });

  return {
    status: combineStatuses(considered.map((section) => section.status)),
    value: makeString(gppSource.value),
    source: gppSource.source,
    applicable_sections: applicableSids,
    sections: decoded
  };
}

function evaluateCmp(data) {
  const preset = data.cmpPreset;
  if (preset === 'onetrust') return evaluateOneTrust(data);
  if (preset === 'cookiebot') return evaluateCookiebot();
  if (preset === 'trustarc') return evaluateTrustArc(data);
  if (preset === 'custom') return evaluateCustomCookie(data);
  return { status: UNKNOWN, preset: preset };
}

function evaluateConsentMode(data, eventData) {
  let status = UNKNOWN;
  let source;

  const consentState = eventData.consent_state;
  if (getType(consentState) === 'object') {
    if (consentState.ad_storage === false || consentState.ad_user_data === false) {
      status = OPT_OUT;
      source = 'consent_state';
    } else if (consentState.ad_storage === true) {
      status = NO_OPT_OUT;
      source = 'consent_state';
    }
  }

  if (status === UNKNOWN) {
    const gcs = makeString(eventData['x-ga-gcs'] || '');
    const adStorage = gcs.indexOf('G1') === 0 ? gcs.charAt(2) : '';
    if (adStorage === '0') {
      status = OPT_OUT;
      source = 'x-ga-gcs';
    } else if (adStorage === '1') {
      status = NO_OPT_OUT;
      source = 'x-ga-gcs';
    }
  }

  if (status !== OPT_OUT && isUIFieldTrue(data.consentModeUseNpa)) {
    const npa = eventData['x-ga-npa'];
    if (npa === '1' || npa === 1 || npa === true) {
      status = OPT_OUT;
      source = 'x-ga-npa';
    }
  }

  if (status !== OPT_OUT && isUIFieldTrue(data.consentModeUseRdp)) {
    const rdp = getSystemProperty(eventData, 'rdp');
    if (rdp === true || rdp === '1' || rdp === 1) {
      status = OPT_OUT;
      source = 'x-sst-system_properties.rdp';
    }
  }

  return { status: status, source: source };
}

/*==============================================================================
  Resolution and output
==============================================================================*/

function resolveSignals(data, signalResults) {
  const order = getSignalOrder(data);
  const priorityMode = data.resolutionMode === 'priority';

  for (let i = 0; i < order.length; i++) {
    const name = order[i];
    const status = signalResults[name].status;
    if (status === OPT_OUT) return { optedOut: true, decidedBy: name };
    if (priorityMode && status === NO_OPT_OUT) return { optedOut: false, decidedBy: name };
  }

  const hasClearAnswer = order.some((name) => signalResults[name].status === NO_OPT_OUT);
  if (!hasClearAnswer && data.noSignalBehavior === 'optOut') {
    return { optedOut: true, decidedBy: 'no_clear_signal' };
  }
  return { optedOut: false, decidedBy: undefined };
}

function buildResult(data, geo, applies, resolution, signalResults) {
  const restrictedAction = data.optOutAction === 'block' ? 'block' : 'limited';
  const decision = applies && resolution.optedOut ? restrictedAction : 'allow';
  const restricted = decision !== 'allow';

  let reason;
  if (!applies) reason = 'region_not_applicable';
  else if (resolution.decidedBy) reason = resolution.decidedBy;
  else reason = 'no_opt_out_signal';

  const signals = {};
  SIGNAL_NAMES.forEach((name) => {
    signals[name] = signalResults[name].status;
  });

  return {
    decision: decision,
    restricted: restricted,
    opted_out: resolution.optedOut,
    reason: reason,
    applies: applies,
    country: geo.country,
    region: geo.region,
    geo_source: geo.source,
    signals: signals,
    details: signalResults,
    vendor: buildVendorFlags(data, geo, restricted)
  };
}

function buildVendorFlags(data, geo, restricted) {
  let metaCountry;
  let metaState;
  if (restricted) {
    const explicitUs = data.metaDpoMode === 'us';
    metaCountry = explicitUs ? 1 : 0;
    metaState = explicitUs && geo.region === 'CA' ? 1000 : 0;
  }

  return {
    meta: {
      data_processing_options: restricted ? ['LDU'] : [],
      data_processing_options_country: metaCountry,
      data_processing_options_state: metaState
    },
    google_ads: { restricted_data_processing: restricted },
    tiktok: { limited_data_use: restricted }
  };
}

function getReturnValue(data, result) {
  const vendor = result.vendor;
  switch (data.returnType) {
    case 'restricted':
      return result.restricted;
    case 'object':
      return result;
    case 'metaDpo':
      return vendor.meta.data_processing_options;
    case 'metaDpoCountry':
      return vendor.meta.data_processing_options_country;
    case 'metaDpoState':
      return vendor.meta.data_processing_options_state;
    case 'googleAdsRdp':
      return vendor.google_ads.restricted_data_processing;
    case 'tiktokLdu':
      return vendor.tiktok.limited_data_use;
    default:
      return result.decision;
  }
}

function getSignalOrder(data) {
  const order = [];
  const rows = getType(data.signalPriority) === 'array' ? data.signalPriority : [];
  rows.forEach((row) => {
    const name = row && row.signal;
    if (SIGNAL_NAMES.indexOf(name) !== -1 && order.indexOf(name) === -1) order.push(name);
  });
  SIGNAL_NAMES.forEach((name) => {
    if (order.indexOf(name) === -1) order.push(name);
  });
  return order;
}

/*==============================================================================
  Geo
==============================================================================*/

function getGeo(data, eventData) {
  if (data.geoSource === 'custom') {
    return normalizeGeo(data.customCountry, data.customRegion, 'custom');
  }

  const location = eventData.event_location;
  if (getType(location) === 'object' && isKnownCountry(location.country)) {
    return normalizeGeo(location.country, location.region, 'event_location');
  }

  const headerSources = [
    { country: 'x-geo-country', region: 'x-geo-region', source: 'x-geo' },
    { country: 'x-gclb-country', region: 'x-gclb-region', source: 'x-gclb' },
    { country: 'cf-ipcountry', source: 'cf' }
  ];
  for (let i = 0; i < headerSources.length; i++) {
    const headerSource = headerSources[i];
    const country = getRequestHeader(headerSource.country);
    if (isKnownCountry(country)) {
      const region = headerSource.region ? getRequestHeader(headerSource.region) : undefined;
      return normalizeGeo(country, region, headerSource.source);
    }
  }

  return { country: undefined, region: undefined, source: 'none' };
}

function normalizeGeo(country, region, source) {
  const normalizedCountry = isKnownCountry(country)
    ? makeString(country).trim().toUpperCase()
    : undefined;
  return {
    country: normalizedCountry,
    region: normalizeRegion(region, normalizedCountry),
    source: source
  };
}

function normalizeRegion(region, country) {
  if (!isValidValue(region)) return undefined;
  const value = makeString(region).trim();
  if (!value) return undefined;
  const upper = value.toUpperCase();

  if (country && upper.indexOf(country + '-') === 0) return upper.slice(country.length + 1);
  if (country === 'US' && upper.length === 4 && upper.indexOf('US') === 0) return upper.slice(2);
  if (upper.length <= 3) return upper;

  if (!country || country === 'US') {
    const stateCode = US_STATE_CODES[value.toLowerCase()];
    if (stateCode) return stateCode;
  }
  return upper;
}

function isKnownCountry(country) {
  if (!isValidValue(country)) return false;
  const value = makeString(country).trim().toUpperCase();
  return value.length === 2 && value !== 'XX' && value !== 'ZZ';
}

function isRegionApplicable(data, geo) {
  const scope = data.regionScope || 'us';
  const applyWhenUnknown = data.unknownGeoBehavior !== 'skip';

  if (scope === 'everywhere') return true;
  if (!geo.country) return applyWhenUnknown;
  if (geo.country !== 'US') return false;
  if (scope === 'us') return true;

  if (!geo.region) return applyWhenUnknown;
  return parseList(data.regionStates).indexOf(geo.region) !== -1;
}

/*==============================================================================
  Vendor related functions
==============================================================================*/

function evaluateOneTrust(data) {
  const raw = getCookieValues('OptanonConsent')[0];
  if (!isValidValue(raw)) return { status: UNKNOWN, preset: 'onetrust', cookie_found: false };

  const category = makeString(data.oneTrustCategory || 'C0004').trim();
  const decoded = safeDecode(raw);
  const groups = getQueryLikeParam(decoded, 'groups');
  let status = UNKNOWN;
  if (groups) {
    safeDecode(groups)
      .split(',')
      .forEach((entry) => {
        const parts = entry.trim().split(':');
        if (parts[0] !== category) return;
        if (parts[1] === '0') status = OPT_OUT;
        else if (parts[1] === '1') status = NO_OPT_OUT;
      });
  }

  const browserGpc = makeString(getQueryLikeParam(decoded, 'browserGpcFlag') || '').trim() === '1';
  if (browserGpc) status = OPT_OUT;

  return {
    status: status,
    preset: 'onetrust',
    cookie_found: true,
    category: category,
    browser_gpc: browserGpc
  };
}

function evaluateCookiebot() {
  const raw = getCookieValues('CookieConsent')[0];
  if (!isValidValue(raw)) return { status: UNKNOWN, preset: 'cookiebot', cookie_found: false };

  const value = safeDecode(raw).split(' ').join('').split('"').join('').split("'").join('');
  let status = UNKNOWN;
  if (value.indexOf('marketing:false') !== -1) status = OPT_OUT;
  else if (value.indexOf('marketing:true') !== -1) status = NO_OPT_OUT;
  return { status: status, preset: 'cookiebot', cookie_found: true };
}

function evaluateTrustArc(data) {
  const advertisingIndex = makeString(
    isValidValue(data.trustArcCategory) ? data.trustArcCategory : 2
  );

  const gdprPrefs = getCookieValues('notice_gdpr_prefs')[0];
  if (isValidValue(gdprPrefs)) {
    const categories = safeDecode(gdprPrefs)
      .split(':')[0]
      .split(',')
      .map((entry) => entry.trim());
    let status = categories.indexOf(advertisingIndex) !== -1 ? NO_OPT_OUT : OPT_OUT;
    if (!categories.every(isDigits) || categories.indexOf(TRUSTARC_NOT_PROVISIONED) !== -1) {
      status = UNKNOWN;
    }
    return trustArcResult(status, 'notice_gdpr_prefs');
  }

  const preferences = getCookieValues('notice_preferences')[0];
  if (isValidValue(preferences)) {
    const level = safeDecode(preferences).split(':')[0].trim();
    let status = UNKNOWN;
    if (isDigits(level) && level !== TRUSTARC_NOT_PROVISIONED) {
      status = makeInteger(level) >= makeInteger(advertisingIndex) ? NO_OPT_OUT : OPT_OUT;
    }
    return trustArcResult(status, 'notice_preferences');
  }

  return { status: UNKNOWN, preset: 'trustarc', cookie_found: false };
}

function trustArcResult(status, cookie) {
  return { status: status, preset: 'trustarc', cookie_found: true, cookie: cookie };
}

function evaluateCustomCookie(data) {
  const cookieName = makeString(data.cmpCustomCookieName || '').trim();
  if (!cookieName) return { status: UNKNOWN, preset: 'custom', cookie_found: false };

  const raw = getCookieValues(cookieName)[0];
  if (!isValidValue(raw)) {
    return { status: UNKNOWN, preset: 'custom', cookie: cookieName, cookie_found: false };
  }

  const value = makeString(raw);
  let status = UNKNOWN;
  if (matchesCookieValue(value, data.cmpCustomMatchType, data.cmpCustomOptOutValue)) {
    status = OPT_OUT;
  } else if (matchesCookieValue(value, data.cmpCustomMatchType, data.cmpCustomOptInValue)) {
    status = NO_OPT_OUT;
  }
  return { status: status, preset: 'custom', cookie: cookieName, cookie_found: true };
}

function matchesCookieValue(value, matchType, expected) {
  if (!isValidValue(expected)) return false;
  const pattern = makeString(expected);
  if (matchType === 'contains') return value.indexOf(pattern) !== -1;
  if (matchType === 'regex') {
    const regex = createRegex(pattern, 'i');
    return regex ? testRegex(regex, value) : false;
  }
  return value === pattern;
}

function parseUsPrivacyString(value) {
  const usp = makeString(value).trim().toUpperCase();
  if (usp.length !== 4 || usp.charAt(0) !== '1') return UNKNOWN;
  const optOut = usp.charAt(2);
  if (optOut === 'Y') return OPT_OUT;
  if (optOut === 'N') return NO_OPT_OUT;
  return UNKNOWN;
}

/*==============================================================================
  GPP decoding (IAB Global Privacy Platform)
==============================================================================*/

function decodeGppString(gppString) {
  const parts = gppString.trim().split('~');
  const sectionIds = decodeGppHeader(parts[0]);
  if (!sectionIds) return undefined;

  const sections = [];
  for (let i = 0; i < sectionIds.length; i++) {
    const encodedSection = parts[i + 1];
    if (!isValidValue(encodedSection)) break;
    sections.push(decodeGppSection(sectionIds[i], encodedSection));
  }
  return sections;
}

function decodeGppHeader(encodedHeader) {
  const bits = base64ToBits(encodedHeader);
  if (!bits || readBitsInt(bits, 0, 6) !== 3) return undefined;

  const entries = readBitsInt(bits, 12, 12);
  if (entries === undefined) return undefined;

  const ids = [];
  let position = 24;
  let lastId = 0;
  for (let i = 0; i < entries; i++) {
    if (position >= bits.length) return undefined;
    const isRange = bits.charAt(position) === '1';
    position++;

    const offset = readFibonacci(bits, position);
    if (!offset) return undefined;
    position = offset.next;
    const startId = lastId + offset.value;
    if (startId > MAX_GPP_SECTION_ID) return undefined;

    if (isRange) {
      const length = readFibonacci(bits, position);
      if (!length) return undefined;
      position = length.next;
      const endId = startId + length.value;
      if (endId > MAX_GPP_SECTION_ID) return undefined;
      for (let id = startId; id <= endId; id++) ids.push(id);
      lastId = endId;
    } else {
      ids.push(startId);
      lastId = startId;
    }
  }
  return ids;
}

function decodeGppSection(sectionId, encodedSection) {
  const definition = GPP_SECTIONS[sectionId];
  if (!definition) return { id: sectionId, status: UNKNOWN, supported: false };

  if (definition.name === 'uspv1') {
    return {
      id: sectionId,
      name: 'uspv1',
      value: encodedSection,
      status: parseUsPrivacyString(encodedSection)
    };
  }

  const segments = encodedSection.split('.');
  const coreBits = base64ToBits(segments[0]);
  const version = coreBits ? readBitsInt(coreBits, 0, 6) : undefined;
  const section = { id: sectionId, name: definition.name, version: version };

  if (!coreBits || definition.versions.indexOf(version) === -1) {
    section.status = UNKNOWN;
    section.supported = false;
    return section;
  }

  const statuses = [];
  definition.fields.forEach((field) => {
    const fieldValue = readBitsInt(coreBits, field.offset, 2);
    section[field.name + '_opt_out'] = fieldValue;
    statuses.push(optOutFieldToStatus(fieldValue));
  });

  if (definition.hasGpcSegment) {
    for (let i = 1; i < segments.length; i++) {
      const segmentBits = base64ToBits(segments[i]);
      if (segmentBits && readBitsInt(segmentBits, 0, 2) === 1) {
        section.gpc = readBitsInt(segmentBits, 2, 1) === 1;
        if (section.gpc) statuses.push(OPT_OUT);
      }
    }
  }

  section.status = combineStatuses(statuses);
  return section;
}

function optOutFieldToStatus(value) {
  if (value === 1) return OPT_OUT;
  if (value === 2) return NO_OPT_OUT;
  return UNKNOWN;
}

function base64ToBits(value) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  if (!isValidValue(value)) return undefined;
  const text = makeString(value);
  if (!text) return undefined;

  let bits = '';
  for (let i = 0; i < text.length; i++) {
    const char = text.charAt(i);
    let index = alphabet.indexOf(char);
    if (char === '-') index = 62;
    if (char === '_') index = 63;
    if (index === -1) return undefined;
    for (let power = 5; power >= 0; power--) {
      const weight = Math.pow(2, power);
      if (index >= weight) {
        bits += '1';
        index = index - weight;
      } else {
        bits += '0';
      }
    }
  }
  return bits;
}

function readBitsInt(bits, start, length) {
  if (start + length > bits.length) return undefined;
  let value = 0;
  for (let i = start; i < start + length; i++) {
    value = value * 2 + (bits.charAt(i) === '1' ? 1 : 0);
  }
  return value;
}

function readFibonacci(bits, start) {
  let value = 0;
  let previous = 1;
  let current = 1;
  let lastBit = '0';
  for (let i = start; i < bits.length; i++) {
    const bit = bits.charAt(i);
    if (bit === '1' && lastBit === '1') return { value: value, next: i + 1 };
    if (bit === '1') value += current;
    const nextFibonacci = previous + current;
    previous = current;
    current = nextFibonacci;
    lastBit = bit;
  }
  return undefined;
}

function parseSidList(value) {
  if (getType(value) === 'array') {
    return value.map((item) => makeInteger(item)).filter((item) => item > 0);
  }
  return makeString(value)
    .split('_')
    .join(',')
    .split(',')
    .map((item) => item.trim())
    .filter((item) => isDigits(item))
    .map((item) => makeInteger(item))
    .filter((item) => item > 0);
}

/*==============================================================================
  Helpers
==============================================================================*/

function combineStatuses(statuses) {
  if (statuses.indexOf(OPT_OUT) !== -1) return OPT_OUT;
  if (statuses.indexOf(NO_OPT_OUT) !== -1) return NO_OPT_OUT;
  return UNKNOWN;
}

function getSystemProperty(eventData, key) {
  const properties = eventData['x-sst-system_properties'];
  if (getType(properties) === 'object' && isValidValue(properties[key])) return properties[key];
  return eventData['x-sst-system_properties.' + key];
}

function getFirstValid(candidates) {
  for (let i = 0; i < candidates.length; i++) {
    if (isValidValue(candidates[i][0])) {
      return { value: candidates[i][0], source: candidates[i][1] };
    }
  }
  return undefined;
}

function getQueryLikeParam(value, name) {
  const pairs = value.split('&');
  for (let i = 0; i < pairs.length; i++) {
    const separatorIndex = pairs[i].indexOf('=');
    if (separatorIndex !== -1 && pairs[i].slice(0, separatorIndex).trim() === name) {
      return pairs[i].slice(separatorIndex + 1);
    }
  }
  return undefined;
}

function safeDecode(value) {
  const text = makeString(value);
  if (text.indexOf('%') === -1) return text;
  return decodeUriComponent(text) || text;
}

function parseList(value) {
  if (!isValidValue(value)) return [];
  return makeString(value)
    .split(',')
    .map((item) => item.trim().toUpperCase())
    .filter((item) => item.length > 0);
}

function isDigits(value) {
  if (!value) return false;
  for (let i = 0; i < value.length; i++) {
    if ('0123456789'.indexOf(value.charAt(i)) === -1) return false;
  }
  return true;
}

function isUIFieldTrue(field) {
  return [true, 'true'].indexOf(field) !== -1;
}

function isValidValue(value) {
  const valueType = getType(value);
  if (valueType === 'null' || valueType === 'undefined' || value !== value) return false;
  return value !== '' && value !== 'undefined' && value !== 'null';
}
