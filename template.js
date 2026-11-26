const createRegex = require('createRegex');
const decodeUriComponent = require('decodeUriComponent');
const getAllEventData = require('getAllEventData');
const getCookieValues = require('getCookieValues');
const getRequestHeader = require('getRequestHeader');
const getType = require('getType');
const makeInteger = require('makeInteger');
const makeString = require('makeString');
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
  9: saleAndTargetedSection('usva', 12, false),
  10: saleAndTargetedSection('usco', 12, true),
  11: saleAndTargetedSection('usut', 14, false),
  12: saleAndTargetedSection('usct', 12, true),
  13: saleAndTargetedSection('usfl', 12, false),
  14: saleAndTargetedSection('usmt', 12, true),
  15: saleAndTargetedSection('usor', 12, true),
  16: saleAndTargetedSection('ustx', 12, true),
  17: saleAndTargetedSection('usde', 12, true),
  18: saleAndTargetedSection('usia', 14, true),
  19: saleAndTargetedSection('usne', 12, true),
  20: saleAndTargetedSection('usnh', 12, true),
  21: saleAndTargetedSection('usnj', 12, true),
  22: saleAndTargetedSection('ustn', 12, true),
  23: saleAndTargetedSection('usmn', 12, true),
  24: saleAndTargetedSection('usmd', 16, true),
  25: saleAndTargetedSection('usin', 16, false),
  26: saleAndTargetedSection('usky', 16, false),
  27: saleAndTargetedSection('usri', 16, false)
};

const META_STATE_CODES = {
  CA: 1000,
  CO: 1001,
  CT: 1002,
  FL: 1003,
  OR: 1004,
  TX: 1005,
  MT: 1006,
  DE: 1007,
  NE: 1008,
  NH: 1009,
  NJ: 1010,
  MN: 1011,
  MD: 1012,
  RI: 1013
};

const GCD_ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_';
const GCD_CONSENT_TYPES = ['ad_storage', 'analytics_storage', 'ad_user_data', 'ad_personalization'];
const OPT_OUT_CONSENT_TYPES = ['ad_storage', 'ad_user_data', 'ad_personalization'];

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
const gcd = decodeGcd(eventData['x-ga-gcd']);

const geo = getGeo(data, eventData);
const applies = isRegionApplicable(data, geo);

const signalResults = {
  gpc: isUIFieldTrue(data.enableGpc) ? evaluateGpc(gcd) : { status: DISABLED },
  gpp: isUIFieldTrue(data.enableGpp) ? evaluateGpp(data, eventData) : { status: DISABLED },
  us_privacy: isUIFieldTrue(data.enableUsPrivacy)
    ? evaluateUsPrivacy(data, eventData)
    : { status: DISABLED },
  cmp: isUIFieldTrue(data.enableCmp) ? evaluateCmp(data) : { status: DISABLED },
  consent_mode: isUIFieldTrue(data.enableConsentMode)
    ? evaluateConsentMode(data, eventData, gcd)
    : { status: DISABLED }
};

const resolution = resolveSignals(data, signalResults);
const result = buildResult(data, geo, applies, resolution, signalResults);

return getReturnValue(data, result);

/*==============================================================================
  Signal evaluation
==============================================================================*/

function evaluateGpc(gcd) {
  const header = getRequestHeader('sec-gpc');
  const value = isValidValue(header) ? makeString(header).split(',')[0].trim() : undefined;
  if (value === '1') return { status: OPT_OUT, value: value, source: 'sec-gpc' };
  if (gcd && gcd.gpc) return { status: OPT_OUT, value: value, source: 'x-ga-gcd' };
  return { status: UNKNOWN, value: value };
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

function evaluateConsentMode(data, eventData, gcd) {
  const result = readConsentState(eventData.consent_state) ||
    readGcdConsent(gcd, eventData['x-ga-gcd']) ||
    readGcs(eventData['x-ga-gcs']) || { status: UNKNOWN };

  if (result.status !== OPT_OUT && isUIFieldTrue(data.consentModeUseNpa)) {
    const npa = eventData['x-ga-npa'];
    if (npa === '1' || npa === 1 || npa === true) {
      result.status = OPT_OUT;
      result.source = 'x-ga-npa';
    }
  }

  if (result.status !== OPT_OUT && isUIFieldTrue(data.consentModeUseRdp)) {
    const rdp = getSystemProperty(eventData, 'rdp');
    if (rdp === true || rdp === '1' || rdp === 1) {
      result.status = OPT_OUT;
      result.source = 'x-sst-system_properties.rdp';
    }
  }

  if (result.status === NO_OPT_OUT && data.consentModeReports !== 'all') {
    result.status = UNKNOWN;
    result.granted_reported_as_unknown = true;
  }

  return result;
}

function readConsentState(consentState) {
  if (getType(consentState) !== 'object') return undefined;
  const states = {};
  OPT_OUT_CONSENT_TYPES.forEach((type) => {
    if (consentState[type] === true) states[type] = 'granted';
    else if (consentState[type] === false) states[type] = 'denied';
  });
  return consentStatesToResult(states, 'consent_state');
}

function readGcdConsent(gcd, rawGcd) {
  if (!gcd) return undefined;
  const states = {};
  OPT_OUT_CONSENT_TYPES.forEach((type) => {
    if (gcd.states[type]) states[type] = gcd.states[type];
  });
  const result = consentStatesToResult(states, 'x-ga-gcd');
  if (result) result.value = makeString(rawGcd);
  return result;
}

function readGcs(rawGcs) {
  const gcs = makeString(rawGcs || '');
  const adStorage = gcs.indexOf('G1') === 0 ? gcs.charAt(2) : '';
  const states = {};
  if (adStorage === '0') states.ad_storage = 'denied';
  else if (adStorage === '1') states.ad_storage = 'granted';
  const result = consentStatesToResult(states, 'x-ga-gcs');
  if (result) result.value = gcs;
  return result;
}

function consentStatesToResult(states, source) {
  let status;
  if (OPT_OUT_CONSENT_TYPES.some((type) => states[type] === 'denied')) status = OPT_OUT;
  else if (states.ad_storage === 'granted') status = NO_OPT_OUT;
  if (!status) return undefined;
  return { status: status, source: source, states: states };
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
    metaState = explicitUs && geo.country === 'US' ? META_STATE_CODES[geo.region] || 0 : 0;
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
    {
      country: 'cloudfront-viewer-country',
      region: 'cloudfront-viewer-country-region',
      source: 'cloudfront'
    },
    { country: 'x-appengine-country', region: 'x-appengine-region', source: 'appengine' },
    { country: 'x-azure-country', source: 'azure' },
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
  const sextets = base64ToSextets(encodedHeader);
  if (!sextets || readBitsInt(sextets, 0, 6) !== 3) return undefined;

  const entries = readBitsInt(sextets, 12, 12);
  if (entries === undefined) return undefined;

  const ids = [];
  let position = 24;
  let lastId = 0;
  for (let i = 0; i < entries; i++) {
    if (position >= sextets.length * 6) return undefined;
    const isRange = readBit(sextets, position) === 1;
    position++;

    const offset = readFibonacci(sextets, position);
    if (!offset) return undefined;
    position = offset.next;
    const startId = lastId + offset.value;
    if (startId > MAX_GPP_SECTION_ID) return undefined;

    if (isRange) {
      const length = readFibonacci(sextets, position);
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
  const core = base64ToSextets(segments[0]);
  const version = core ? readBitsInt(core, 0, 6) : undefined;
  const section = { id: sectionId, name: definition.name, version: version };

  if (!core || definition.versions.indexOf(version) === -1) {
    section.status = UNKNOWN;
    section.supported = false;
    return section;
  }

  const statuses = [];
  definition.fields.forEach((field) => {
    const fieldValue = readBitsInt(core, field.offset, 2);
    section[field.name + '_opt_out'] = fieldValue;
    statuses.push(optOutFieldToStatus(fieldValue));
  });

  if (definition.hasGpcSegment) {
    for (let i = 1; i < segments.length; i++) {
      const segment = base64ToSextets(segments[i]);
      if (segment && readBitsInt(segment, 0, 2) === 1) {
        section.gpc = readBit(segment, 2) === 1;
        if (section.gpc) statuses.push(OPT_OUT);
      }
    }
  }

  section.status = combineStatuses(statuses);
  return section;
}

function saleAndTargetedSection(name, saleOffset, hasGpcSegment) {
  return {
    name: name,
    versions: [1],
    fields: [
      { name: 'sale', offset: saleOffset },
      { name: 'targeted_advertising', offset: saleOffset + 2 }
    ],
    hasGpcSegment: hasGpcSegment
  };
}

function optOutFieldToStatus(value) {
  if (value === 1) return OPT_OUT;
  if (value === 2) return NO_OPT_OUT;
  return UNKNOWN;
}

function base64ToSextets(value) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  if (!isValidValue(value)) return undefined;
  const text = makeString(value);
  if (!text) return undefined;

  const sextets = [];
  for (let i = 0; i < text.length; i++) {
    const char = text.charAt(i);
    let index = alphabet.indexOf(char);
    if (char === '-') index = 62;
    if (char === '_') index = 63;
    if (index === -1) return undefined;
    sextets.push(index);
  }
  return sextets;
}

function readBit(sextets, position) {
  return (sextets[(position / 6) | 0] >> (5 - (position % 6))) & 1;
}

function readBitsInt(sextets, start, length) {
  if (start + length > sextets.length * 6) return undefined;
  let value = 0;
  for (let i = start; i < start + length; i++) {
    value = (value << 1) | readBit(sextets, i);
  }
  return value;
}

function readFibonacci(sextets, start) {
  let value = 0;
  let previous = 1;
  let current = 1;
  let lastBit = 0;
  for (let i = start; i < sextets.length * 6; i++) {
    const bit = readBit(sextets, i);
    if (bit === 1 && lastBit === 1) return { value: value, next: i + 1 };
    if (bit === 1) value += current;
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
  gcd decoding (Google Consent Mode, GA4 x-ga-gcd)
==============================================================================*/

function decodeGcd(value) {
  if (!isValidValue(value)) return undefined;
  const text = makeString(value).trim();
  if (text.length < 10 || text.charAt(0) !== '1') return undefined;

  const chars = [];
  for (let i = 0; i < 10; i++) {
    const index = GCD_ALPHABET.indexOf(text.charAt(i));
    if (index === -1) return undefined;
    chars.push(index);
  }

  const entries = {};
  GCD_CONSENT_TYPES.forEach((type, index) => {
    const first = chars[1 + index * 2];
    const second = chars[2 + index * 2];
    entries[type] = {
      delegation: first >> 2,
      defaultState: (second >> 2) & 3,
      updateState: second & 3
    };
  });

  const states = {};
  GCD_CONSENT_TYPES.forEach((type) => {
    const state = resolveGcdState(entries, type);
    if (state) states[type] = state;
  });

  return { states: states, gpc: ((chars[9] >> 3) & 1) === 1 };
}

function resolveGcdState(entries, type) {
  let current = type;
  for (let hops = 0; hops < GCD_CONSENT_TYPES.length; hops++) {
    const delegation = entries[current].delegation;
    if (delegation < 12) break;
    current = GCD_CONSENT_TYPES[delegation - 12];
  }

  const entry = entries[current];
  const state = isGcdStateSet(entry.updateState) ? entry.updateState : entry.defaultState;
  if (state === 3) return 'granted';
  if (state === 2) return 'denied';
  return undefined;
}

function isGcdStateSet(state) {
  return state === 2 || state === 3;
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
