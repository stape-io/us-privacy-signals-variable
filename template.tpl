___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "US Privacy Signals",
  "categories": [
    "UTILITY"
  ],
  "description": "Combines US opt-out signals (GPC, IAB GPP and US Privacy strings, CMP cookies, Consent Mode) and the visitor region into one decision, plus Meta, Google Ads and TikTok limited data use flags.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "returnType",
    "displayName": "Return Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "decision",
        "displayValue": "Decision (allow / limited / block)"
      },
      {
        "value": "restricted",
        "displayValue": "Restricted (true / false)"
      },
      {
        "value": "object",
        "displayValue": "Full object (decision, reason, signals, geo, vendor flags)"
      },
      {
        "value": "metaDpo",
        "displayValue": "Meta - data_processing_options"
      },
      {
        "value": "metaDpoCountry",
        "displayValue": "Meta - data_processing_options_country"
      },
      {
        "value": "metaDpoState",
        "displayValue": "Meta - data_processing_options_state"
      },
      {
        "value": "googleAdsRdp",
        "displayValue": "Google Ads - restricted data processing"
      },
      {
        "value": "tiktokLdu",
        "displayValue": "TikTok - limited_data_use"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "decision",
    "alwaysInSummary": true,
    "help": "\u003cul\u003e\u003cli\u003e\u003cb\u003eDecision\u003c/b\u003e: \u003ccode\u003eallow\u003c/code\u003e, \u003ccode\u003elimited\u003c/code\u003e or \u003ccode\u003eblock\u003c/code\u003e.\u003c/li\u003e\u003cli\u003e\u003cb\u003eRestricted\u003c/b\u003e: \u003ccode\u003etrue\u003c/code\u003e when the decision is \u003ccode\u003elimited\u003c/code\u003e or \u003ccode\u003eblock\u003c/code\u003e.\u003c/li\u003e\u003cli\u003e\u003cb\u003eFull object\u003c/b\u003e: the decision plus the reason, the status of each signal, the visitor location and all vendor flags. Use it in Preview to see why a decision was made.\u003c/li\u003e\u003cli\u003e\u003cb\u003eMeta - data_processing_options\u003c/b\u003e: \u003ccode\u003e[\u0027LDU\u0027]\u003c/code\u003e when restricted, otherwise \u003ccode\u003e[]\u003c/code\u003e.\u003c/li\u003e\u003cli\u003e\u003cb\u003eMeta - data_processing_options_country / _state\u003c/b\u003e: numbers when restricted (see the Meta section below), otherwise \u003ccode\u003eundefined\u003c/code\u003e.\u003c/li\u003e\u003cli\u003e\u003cb\u003eGoogle Ads - restricted data processing\u003c/b\u003e and \u003cb\u003eTikTok - limited_data_use\u003c/b\u003e: \u003ccode\u003etrue\u003c/code\u003e when restricted, otherwise \u003ccode\u003efalse\u003c/code\u003e.\u003c/li\u003e\u003c/ul\u003e"
  },
  {
    "type": "GROUP",
    "name": "decisionGroup",
    "displayName": "Decision",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "RADIO",
        "name": "optOutAction",
        "displayName": "Action when the visitor opted out",
        "radioItems": [
          {
            "value": "limited",
            "displayValue": "Limited (send with limited data use flags)"
          },
          {
            "value": "block",
            "displayValue": "Block"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "limited"
      },
      {
        "type": "SELECT",
        "name": "resolutionMode",
        "displayName": "When signals disagree",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "anyOptOut",
            "displayValue": "Any opt-out wins"
          },
          {
            "value": "priority",
            "displayValue": "First signal with a clear answer wins"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "anyOptOut",
        "help": "\u003cb\u003eAny opt-out wins\u003c/b\u003e: if any enabled signal reports an opt-out, the visitor is treated as opted out. The priority order below only decides which signal is reported as the reason.\u003cbr/\u003e\u003cbr/\u003e\u003cb\u003eFirst signal with a clear answer wins\u003c/b\u003e: signals are checked in the priority order below. The first one that reports either an opt-out or an explicit \"did not opt out\" decides. For example, an explicit CMP choice placed above GPC overrides GPC. GPC can only report an opt-out, never \"did not opt out\"."
      },
      {
        "type": "RADIO",
        "name": "noSignalBehavior",
        "displayName": "When no signal gives a clear answer",
        "radioItems": [
          {
            "value": "allow",
            "displayValue": "Treat as not opted out (allow)"
          },
          {
            "value": "optOut",
            "displayValue": "Treat as opted out (fail closed)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "allow",
        "help": "Applies when no enabled signal reports either an opt-out or an explicit \"did not opt out\", for example when the GPP string is missing or its format is not recognized. With \u003cb\u003efail closed\u003c/b\u003e, those visitors get the opt-out action and the reason \u003ccode\u003eno_clear_signal\u003c/code\u003e.\u003cbr/\u003e\u003cbr/\u003eGPC can only report an opt-out, never \"did not opt out\". With only GPC enabled, every visitor without GPC is treated as opted out. The region rules still apply first."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "signalPriority",
        "displayName": "Signal priority (top \u003d highest)",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Signal",
            "name": "signal",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "gpc",
                "displayValue": "Global Privacy Control (Sec-GPC header)"
              },
              {
                "value": "gpp",
                "displayValue": "IAB GPP string"
              },
              {
                "value": "us_privacy",
                "displayValue": "IAB US Privacy string"
              },
              {
                "value": "cmp",
                "displayValue": "CMP cookie"
              },
              {
                "value": "consent_mode",
                "displayValue": "Google Consent Mode"
              }
            ]
          }
        ],
        "defaultValue": [
          {
            "signal": "gpc"
          },
          {
            "signal": "gpp"
          },
          {
            "signal": "us_privacy"
          },
          {
            "signal": "cmp"
          },
          {
            "signal": "consent_mode"
          }
        ],
        "newRowButtonText": "Add signal",
        "help": "Signals missing from this table are checked after the listed ones, in the default order: GPC, GPP, US Privacy, CMP, Consent Mode."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "signalsGroup",
    "displayName": "Signals",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableGpc",
        "checkboxText": "Global Privacy Control (Sec-GPC request header)",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Browsers with GPC turned on send \u003ccode\u003eSec-GPC: 1\u003c/code\u003e with every request. A value of \u003ccode\u003e1\u003c/code\u003e is an opt-out. If your server container sits behind a CDN or proxy, make sure it forwards this header."
      },
      {
        "type": "CHECKBOX",
        "name": "enableGpp",
        "checkboxText": "IAB Global Privacy Platform (GPP) string",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "The Google tag forwards the GPP string from the CMP\u0027s \u003ccode\u003e__gpp\u003c/code\u003e API automatically. It is read from the \u003ccode\u003ex-sst-system_properties.gpp\u003c/code\u003e and \u003ccode\u003ex-sst-system_properties.gpp_sid\u003c/code\u003e Event Data keys (then \u003ccode\u003ex-ads-gpp\u003c/code\u003e / \u003ccode\u003ex-ads-gpp_sid\u003c/code\u003e, then the \u003ccode\u003eOTGPPConsent\u003c/code\u003e cookie that OneTrust writes when GPP is configured).\u003cbr/\u003e\u003cbr/\u003eDecoded sections: US National (7, versions 1 and 2), California (8), Virginia (9), Colorado (10), Utah (11), Connecticut (12) and the legacy US Privacy section (6). A section is an opt-out when its Sale, Sharing or Targeted Advertising opt-out field is \u003ci\u003eOpted Out\u003c/i\u003e, or when its GPC sub-section is set. Other sections are reported as unknown."
      },
      {
        "type": "TEXT",
        "name": "gppString",
        "displayName": "GPP string (optional override)",
        "simpleValueType": true,
        "help": "Leave empty to read it from Event Data. Use this when the GPP string arrives under another key, for example from the Data Client.",
        "enablingConditions": [
          {
            "paramName": "enableGpp",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "gppSid",
        "displayName": "GPP applicable section IDs (optional override)",
        "simpleValueType": true,
        "help": "Comma or underscore separated section IDs, for example \u003ccode\u003e7\u003c/code\u003e or \u003ccode\u003e7_8\u003c/code\u003e. When present, only these sections are evaluated. Leave empty to read it from Event Data.",
        "enablingConditions": [
          {
            "paramName": "enableGpp",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableUsPrivacy",
        "checkboxText": "IAB US Privacy string (us_privacy)",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "The 4-character CCPA string, for example \u003ccode\u003e1YYN\u003c/code\u003e. The third character is the opt-out: \u003ccode\u003eY\u003c/code\u003e \u003d opted out, \u003ccode\u003eN\u003c/code\u003e \u003d not opted out. It is read from \u003ccode\u003ex-sst-system_properties.us_privacy\u003c/code\u003e, \u003ccode\u003ex-ads-us_privacy\u003c/code\u003e, then the \u003ccode\u003eusprivacy\u003c/code\u003e and \u003ccode\u003eus_privacy\u003c/code\u003e cookies."
      },
      {
        "type": "TEXT",
        "name": "usPrivacyString",
        "displayName": "US Privacy string (optional override)",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enableUsPrivacy",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableCmp",
        "checkboxText": "CMP cookie",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Reads the consent cookie of your CMP. The cookie is only available when the server container runs on a subdomain of your website (same-site cookies)."
      },
      {
        "type": "SELECT",
        "name": "cmpPreset",
        "displayName": "CMP",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "onetrust",
            "displayValue": "OneTrust (OptanonConsent)"
          },
          {
            "value": "cookiebot",
            "displayValue": "Cookiebot (CookieConsent)"
          },
          {
            "value": "trustarc",
            "displayValue": "TrustArc (notice_gdpr_prefs / notice_preferences)"
          },
          {
            "value": "custom",
            "displayValue": "Custom cookie"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "onetrust",
        "help": "Usercentrics keeps consent in the browser\u0027s local storage, which the server cannot read. For Usercentrics, use its GPP output or write a custom cookie and pick \u003cb\u003eCustom cookie\u003c/b\u003e.",
        "enablingConditions": [
          {
            "paramName": "enableCmp",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "oneTrustCategory",
        "displayName": "OneTrust targeting category ID",
        "simpleValueType": true,
        "defaultValue": "C0004",
        "help": "The category that covers sale, sharing and targeted advertising. \u003ccode\u003eC0004:0\u003c/code\u003e in the \u003ccode\u003egroups\u003c/code\u003e value is an opt-out, \u003ccode\u003eC0004:1\u003c/code\u003e is not. \u003ccode\u003ebrowserGpcFlag\u003d1\u003c/code\u003e in the cookie (the browser had GPC turned on) is also an opt-out.",
        "enablingConditions": [
          {
            "paramName": "cmpPreset",
            "paramValue": "onetrust",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "trustArcCategory",
        "displayName": "TrustArc advertising category index",
        "simpleValueType": true,
        "defaultValue": "2",
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ],
        "help": "\u003ccode\u003e0\u003c/code\u003e \u003d required, \u003ccode\u003e1\u003c/code\u003e \u003d functional, \u003ccode\u003e2\u003c/code\u003e \u003d advertising. The visitor opted out when this index is missing from \u003ccode\u003enotice_gdpr_prefs\u003c/code\u003e, or when the \u003ccode\u003enotice_preferences\u003c/code\u003e level is lower than it.",
        "enablingConditions": [
          {
            "paramName": "cmpPreset",
            "paramValue": "trustarc",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "cmpCustomCookieName",
        "displayName": "Cookie name",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "cmpPreset",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "SELECT",
        "name": "cmpCustomMatchType",
        "displayName": "Match type",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "equals",
            "displayValue": "Equals"
          },
          {
            "value": "contains",
            "displayValue": "Contains"
          },
          {
            "value": "regex",
            "displayValue": "Matches RegEx (ignore case)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "equals",
        "enablingConditions": [
          {
            "paramName": "cmpPreset",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "cmpCustomOptOutValue",
        "displayName": "Value that means opted out",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "cmpPreset",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "cmpCustomOptInValue",
        "displayName": "Value that means not opted out (optional)",
        "simpleValueType": true,
        "help": "Only matters in the \u003cb\u003eFirst signal with a clear answer wins\u003c/b\u003e mode. Without it, a cookie that does not match the opt-out value is reported as unknown.",
        "enablingConditions": [
          {
            "paramName": "cmpPreset",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableConsentMode",
        "checkboxText": "Google Consent Mode",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Reads the Data Tag \u003ccode\u003econsent_state\u003c/code\u003e (\u003ccode\u003ead_storage\u003c/code\u003e or \u003ccode\u003ead_user_data\u003c/code\u003e \u003d false is an opt-out), then the GA4 \u003ccode\u003ex-ga-gcs\u003c/code\u003e value (ad_storage denied is an opt-out)."
      },
      {
        "type": "CHECKBOX",
        "name": "consentModeUseNpa",
        "checkboxText": "Treat x-ga-npa \u003d 1 (ads personalization disabled) as an opt-out",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "The Google tag sets \u003ccode\u003enpa\u003d1\u003c/code\u003e when ads personalization is disabled, for example when GPC is honored by the Google tag\u0027s region settings.",
        "enablingConditions": [
          {
            "paramName": "enableConsentMode",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "consentModeUseRdp",
        "checkboxText": "Treat restricted data processing set on the website as an opt-out",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Reads \u003ccode\u003ex-sst-system_properties.rdp\u003c/code\u003e, which the Google tag sends when \u003ccode\u003erestricted_data_processing\u003c/code\u003e is set to true.",
        "enablingConditions": [
          {
            "paramName": "enableConsentMode",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "regionGroup",
    "displayName": "Region Rules",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "RADIO",
        "name": "regionScope",
        "displayName": "Apply opt-out logic to",
        "radioItems": [
          {
            "value": "us",
            "displayValue": "All United States traffic"
          },
          {
            "value": "states",
            "displayValue": "Selected US states"
          },
          {
            "value": "everywhere",
            "displayValue": "All traffic, any country"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "us",
        "help": "Outside this scope the decision is always \u003ccode\u003eallow\u003c/code\u003e, with the reason \u003ccode\u003eregion_not_applicable\u003c/code\u003e."
      },
      {
        "type": "TEXT",
        "name": "regionStates",
        "displayName": "US states (comma-separated 2-letter codes)",
        "simpleValueType": true,
        "defaultValue": "CA,CO,CT,DE,FL,IA,IN,KY,MD,MN,MT,NE,NH,NJ,OR,RI,TN,TX,UT,VA",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "The default list holds the states with a GPP section (states with comprehensive privacy laws). Review it with your legal team.",
        "enablingConditions": [
          {
            "paramName": "regionScope",
            "paramValue": "states",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "RADIO",
        "name": "unknownGeoBehavior",
        "displayName": "When the location is unknown",
        "radioItems": [
          {
            "value": "apply",
            "displayValue": "Apply opt-out logic"
          },
          {
            "value": "skip",
            "displayValue": "Do not apply (allow)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "apply",
        "enablingConditions": [
          {
            "paramName": "regionScope",
            "paramValue": "everywhere",
            "type": "NOT_EQUALS"
          }
        ]
      },
      {
        "type": "RADIO",
        "name": "geoSource",
        "displayName": "Visitor location source",
        "radioItems": [
          {
            "value": "auto",
            "displayValue": "Automatic"
          },
          {
            "value": "custom",
            "displayValue": "Custom variables"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "auto",
        "help": "\u003cb\u003eAutomatic\u003c/b\u003e reads country and region together from the first source that has a country:\u003col\u003e\u003cli\u003eEvent Data \u003ccode\u003eevent_location\u003c/code\u003e (sent by the Google tag as the \u003ccode\u003eur\u003c/code\u003e parameter).\u003c/li\u003e\u003cli\u003eStape GEO Headers power-up: \u003ccode\u003eX-GEO-Country\u003c/code\u003e / \u003ccode\u003eX-GEO-Region\u003c/code\u003e.\u003c/li\u003e\u003cli\u003e\u003ccode\u003eX-Gclb-Country\u003c/code\u003e / \u003ccode\u003eX-Gclb-Region\u003c/code\u003e.\u003c/li\u003e\u003cli\u003e\u003ccode\u003eCF-IPCountry\u003c/code\u003e (country only).\u003c/li\u003e\u003c/ol\u003e",
        "enablingConditions": [
          {
            "paramName": "regionScope",
            "paramValue": "everywhere",
            "type": "NOT_EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "customCountry",
        "displayName": "Country (ISO 3166-1 alpha-2)",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "geoSource",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "customRegion",
        "displayName": "Region (state code, e.g. CA or US-CA)",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "geoSource",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "metaGroup",
    "displayName": "Meta Limited Data Use",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "RADIO",
        "name": "metaDpoMode",
        "displayName": "Country and state values when restricted",
        "radioItems": [
          {
            "value": "geolocation",
            "displayValue": "Let Meta geolocate (country 0, state 0)"
          },
          {
            "value": "us",
            "displayValue": "United States (country 1; state 1000 for California, otherwise 0)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "geolocation",
        "help": "Values returned for \u003ccode\u003edata_processing_options_country\u003c/code\u003e and \u003ccode\u003edata_processing_options_state\u003c/code\u003e when the decision is restricted. When it is \u003ccode\u003eallow\u003c/code\u003e, both are \u003ccode\u003eundefined\u003c/code\u003e and \u003ccode\u003edata_processing_options\u003c/code\u003e is \u003ccode\u003e[]\u003c/code\u003e."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "sec-gpc"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-geo-country"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-geo-region"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gclb-country"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gclb-region"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "cf-ipcountry"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: '[Default] Returns allow when no signal is present'
  code: |-
    const mockData = createMockData({ returnType: undefined });

    assertThat(runCode(mockData)).isEqualTo('allow');

    const result = runCode(createMockData({}));
    assertThat(result.decision).isEqualTo('allow');
    assertThat(result.restricted).isFalse();
    assertThat(result.opted_out).isFalse();
    assertThat(result.reason).isEqualTo('no_opt_out_signal');
    assertThat(result.applies).isTrue();
    assertThat(result.signals).isEqualTo({
      gpc: 'unknown',
      gpp: 'unknown',
      us_privacy: 'unknown',
      cmp: 'disabled',
      consent_mode: 'disabled'
    });
    assertThat(result.vendor).isEqualTo({
      meta: {
        data_processing_options: [],
        data_processing_options_country: undefined,
        data_processing_options_state: undefined
      },
      google_ads: { restricted_data_processing: false },
      tiktok: { limited_data_use: false }
    });
- name: '[GPC] Sec-GPC header 1 returns limited with reason gpc'
  code: |-
    setRequest({ headers: { 'sec-gpc': '1' } });

    const result = runCode(createMockData({}));

    assertThat(result.decision).isEqualTo('limited');
    assertThat(result.restricted).isTrue();
    assertThat(result.opted_out).isTrue();
    assertThat(result.reason).isEqualTo('gpc');
    assertThat(result.signals.gpc).isEqualTo('opt_out');
    assertThat(result.details.gpc).isEqualTo({ status: 'opt_out', value: '1' });
    assertThat(result.vendor).isEqualTo({
      meta: {
        data_processing_options: ['LDU'],
        data_processing_options_country: 0,
        data_processing_options_state: 0
      },
      google_ads: { restricted_data_processing: true },
      tiktok: { limited_data_use: true }
    });
- name: '[GPC] Only the value 1 is an opt-out, and a disabled signal is ignored'
  code: |-
    [
      { header: '1, 1', enabled: true, expected: 'opt_out' },
      { header: ' 1 ', enabled: true, expected: 'opt_out' },
      { header: '0', enabled: true, expected: 'unknown' },
      { header: 'true', enabled: true, expected: 'unknown' },
      { header: '', enabled: true, expected: 'unknown' },
      { header: undefined, enabled: true, expected: 'unknown' },
      { header: '1', enabled: false, expected: 'disabled' }
    ].forEach((scenario) => {
      setRequest({ headers: { 'sec-gpc': scenario.header } });

      const result = runCode(createMockData({ enableGpc: scenario.enabled }));

      assertThat(result.signals.gpc).isEqualTo(scenario.expected);
      assertThat(result.restricted).isEqualTo(scenario.expected === 'opt_out');
    });
- name: '[GPP] Decodes the US National section (versions 1 and 2 and GPC sub-section)'
  code: |-
    [
      { gpp: fixtures.usnatSaleOptOut, expected: 'opt_out', fields: [1, 2, 2], version: 1 },
      { gpp: fixtures.usnatNoOptOut, expected: 'no_opt_out', fields: [2, 2, 2], version: 1 },
      { gpp: fixtures.usnatTargetedOptOut, expected: 'opt_out', fields: [2, 2, 1], version: 2 },
      { gpp: fixtures.usnatGpcOnly, expected: 'opt_out', fields: [2, 2, 2], version: 1, gpc: true },
      { gpp: fixtures.usnatGpcFalse, expected: 'no_opt_out', fields: [2, 2, 2], version: 1, gpc: false },
      { gpp: fixtures.usnatNotApplicable, expected: 'unknown', fields: [0, 0, 0], version: 1 }
    ].forEach((scenario) => {
      setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: scenario.gpp, gpp_sid: '7' } }) });

      const result = runCode(createMockData({}));
      const section = result.details.gpp.sections[0];

      assertThat(result.signals.gpp).isEqualTo(scenario.expected);
      assertThat(result.details.gpp.applicable_sections).isEqualTo([7]);
      assertThat(section.id).isEqualTo(7);
      assertThat(section.name).isEqualTo('usnat');
      assertThat(section.version).isEqualTo(scenario.version);
      assertThat(section.sale_opt_out).isEqualTo(scenario.fields[0]);
      assertThat(section.sharing_opt_out).isEqualTo(scenario.fields[1]);
      assertThat(section.targeted_advertising_opt_out).isEqualTo(scenario.fields[2]);
      assertThat(section.gpc).isEqualTo(scenario.gpc);
      assertThat(result.reason).isEqualTo(scenario.expected === 'opt_out' ? 'gpp' : 'no_opt_out_signal');
    });
- name: '[GPP] Decodes the state sections 8 to 12'
  code: |-
    [
      { gpp: fixtures.uscaSharingOptOut, id: 8, name: 'usca', expected: 'opt_out', field: 'sharing_opt_out', value: 1 },
      { gpp: fixtures.usvaSaleOptOut, id: 9, name: 'usva', expected: 'opt_out', field: 'sale_opt_out', value: 1 },
      { gpp: fixtures.uscoTargetedOptOut, id: 10, name: 'usco', expected: 'opt_out', field: 'targeted_advertising_opt_out', value: 1 },
      { gpp: fixtures.usutSaleOptOut, id: 11, name: 'usut', expected: 'opt_out', field: 'sale_opt_out', value: 1 },
      { gpp: fixtures.usctNoOptOut, id: 12, name: 'usct', expected: 'no_opt_out', field: 'sale_opt_out', value: 2 }
    ].forEach((scenario) => {
      setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: scenario.gpp } }) });

      const result = runCode(createMockData({}));
      const section = result.details.gpp.sections[0];

      assertThat(result.signals.gpp).isEqualTo(scenario.expected);
      assertThat(section.id).isEqualTo(scenario.id);
      assertThat(section.name).isEqualTo(scenario.name);
      assertThat(section[scenario.field]).isEqualTo(scenario.value);
    });
- name: '[GPP] Decodes multi-section strings, range headers and the uspv1 section'
  code: |-
    setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: fixtures.multiTcfUsnatUsca } }) });
    let result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(result.details.gpp.sections.map((section) => section.id)).isEqualTo([2, 7, 8]);
    assertThat(result.details.gpp.sections[0].supported).isFalse();
    assertThat(result.details.gpp.sections[1].status).isEqualTo('no_opt_out');
    assertThat(result.details.gpp.sections[2].status).isEqualTo('opt_out');

    setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: fixtures.multiRanges } }) });
    result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(result.details.gpp.sections.map((section) => section.name)).isEqualTo(['usnat', 'usca', 'usva']);

    setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: fixtures.uspv1 } }) });
    result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(result.details.gpp.sections[0]).isEqualTo({ id: 6, name: 'uspv1', value: '1YYN', status: 'opt_out' });
- name: '[GPP] Decodes strings produced by the official IAB encoder'
  code: |-
    setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: fixtures.officialUsnatGpc } }) });
    let result = runCode(createMockData({}));
    let section = result.details.gpp.sections[0];
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(section.version).isEqualTo(2);
    assertThat(section.sale_opt_out).isEqualTo(2);
    assertThat(section.sharing_opt_out).isEqualTo(2);
    assertThat(section.targeted_advertising_opt_out).isEqualTo(2);
    assertThat(section.gpc).isTrue();

    setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: fixtures.officialUscaSaleOptOut } }) });
    result = runCode(createMockData({}));
    section = result.details.gpp.sections[0];
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(section.name).isEqualTo('usca');
    assertThat(section.sale_opt_out).isEqualTo(1);
    assertThat(section.sharing_opt_out).isEqualTo(2);
    assertThat(section.gpc).isFalse();

    setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: fixtures.officialMultiNoOptOut } }) });
    result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('no_opt_out');
    assertThat(result.details.gpp.sections.map((item) => item.name)).isEqualTo(['uspv1', 'usnat', 'usva']);
- name: '[GPP] Applicable section IDs limit which sections are evaluated'
  code: |-
    [
      { sid: '7', expected: 'no_opt_out', applicable: [7] },
      { sid: '8', expected: 'opt_out', applicable: [8] },
      { sid: '2_7', expected: 'no_opt_out', applicable: [2, 7] },
      { sid: '7,8', expected: 'opt_out', applicable: [7, 8] },
      { sid: [7], expected: 'no_opt_out', applicable: [7] },
      { sid: '-1', expected: 'unknown', applicable: [] },
      { sid: undefined, expected: 'opt_out', applicable: undefined }
    ].forEach((scenario) => {
      setRequest({
        eventData: usEventData({ 'x-sst-system_properties': { gpp: fixtures.multiTcfUsnatUsca, gpp_sid: scenario.sid } })
      });

      const result = runCode(createMockData({}));

      assertThat(result.signals.gpp).isEqualTo(scenario.expected);
      assertThat(result.details.gpp.applicable_sections).isEqualTo(scenario.applicable);
    });
- name: '[GPP] Reads the string from the override, system properties, x-ads keys, then the OneTrust cookie'
  code: |-
    setRequest({
      eventData: usEventData({ 'x-ads-gpp': fixtures.usnatSaleOptOut, 'x-ads-gpp_sid': '7' }),
      cookies: { OTGPPConsent: fixtures.usnatNoOptOut }
    });
    let result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(result.details.gpp.source).isEqualTo('x-ads-gpp');
    assertThat(result.details.gpp.applicable_sections).isEqualTo([7]);

    setRequest({ cookies: { OTGPPConsent: fixtures.officialUscaSaleOptOut } });
    result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(result.details.gpp.source).isEqualTo('cookie_OTGPPConsent');
    assertThat(result.details.gpp.applicable_sections).isUndefined();

    setRequest({ cookies: { OTGPPConsent: 'not a gpp string!' } });
    result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('unknown');
    assertThat(result.details.gpp.error).isEqualTo('invalid_gpp_string');

    setRequest({ eventData: usEventData({ 'x-sst-system_properties.gpp': fixtures.usnatSaleOptOut }) });
    result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('opt_out');

    setRequest({
      eventData: usEventData({
        'x-sst-system_properties': { gpp: fixtures.usnatNoOptOut },
        'x-ads-gpp': fixtures.usnatSaleOptOut
      })
    });
    result = runCode(createMockData({}));
    assertThat(result.signals.gpp).isEqualTo('no_opt_out');

    result = runCode(createMockData({ gppString: fixtures.usnatSaleOptOut, gppSid: '8' }));
    assertThat(result.details.gpp.value).isEqualTo(fixtures.usnatSaleOptOut);
    assertThat(result.signals.gpp).isEqualTo('unknown');
- name: '[GPP] Invalid, truncated, unsupported and v3 strings are unknown'
  code: |-
    [
      { gpp: 'not a gpp string!', error: 'invalid_gpp_string' },
      { gpp: 'BBABM~1YYN', error: 'invalid_gpp_string' },
      { gpp: 'DBAB', error: 'invalid_gpp_string' },
      { gpp: 'DBABrlFEFUJCw~BAAqAAAAAAA', error: 'invalid_gpp_string' },
      { gpp: 'DBABL', error: undefined, sections: 0 },
      { gpp: fixtures.usnatV3, error: undefined, sections: 1 },
      { gpp: fixtures.unsupportedFlorida, error: undefined, sections: 1 }
    ].forEach((scenario) => {
      setRequest({ eventData: usEventData({ 'x-sst-system_properties': { gpp: scenario.gpp } }) });

      const result = runCode(createMockData({}));

      assertThat(result.signals.gpp).isEqualTo('unknown');
      assertThat(result.details.gpp.error).isEqualTo(scenario.error);
      if (scenario.sections !== undefined) {
        assertThat(result.details.gpp.sections.length).isEqualTo(scenario.sections);
        if (scenario.sections > 0) assertThat(result.details.gpp.sections[0].supported).isFalse();
      }
    });
- name: '[US Privacy] Parses the opt-out character'
  code: |-
    [
      { usp: '1YYN', expected: 'opt_out' },
      { usp: '1nyn', expected: 'opt_out' },
      { usp: '1YNN', expected: 'no_opt_out' },
      { usp: '1---', expected: 'unknown' },
      { usp: '2YYN', expected: 'unknown' },
      { usp: '1YY', expected: 'unknown' }
    ].forEach((scenario) => {
      setRequest({ eventData: usEventData({ 'x-sst-system_properties': { us_privacy: scenario.usp } }) });

      const result = runCode(createMockData({}));

      assertThat(result.signals.us_privacy).isEqualTo(scenario.expected);
      assertThat(result.details.us_privacy.value).isEqualTo(scenario.usp);
    });
- name: '[US Privacy] Reads the override, event data keys and cookies in order'
  code: |-
    [
      {
        request: { eventData: usEventData({ 'x-sst-system_properties': { us_privacy: '1YNN' }, 'x-ads-us_privacy': '1YYN' }), cookies: { usprivacy: '1YYN' } },
        overrides: { usPrivacyString: '1YYY' },
        source: 'variable'
      },
      {
        request: { eventData: usEventData({ 'x-sst-system_properties': { us_privacy: '1YNN' }, 'x-ads-us_privacy': '1YYN' }) },
        overrides: {},
        source: 'x-sst-system_properties.us_privacy'
      },
      {
        request: { eventData: usEventData({ 'x-ads-us_privacy': '1YYN' }), cookies: { usprivacy: '1YNN' } },
        overrides: {},
        source: 'x-ads-us_privacy'
      },
      {
        request: { cookies: { usprivacy: '1YYN', us_privacy: '1YNN' } },
        overrides: {},
        source: 'cookie_usprivacy'
      },
      {
        request: { cookies: { us_privacy: '1YYN' } },
        overrides: {},
        source: 'cookie_us_privacy'
      }
    ].forEach((scenario) => {
      setRequest(scenario.request);

      const result = runCode(createMockData(scenario.overrides));

      assertThat(result.details.us_privacy.source).isEqualTo(scenario.source);
    });

    setRequest({});
    assertThat(runCode(createMockData({ enableUsPrivacy: false, usPrivacyString: '1YYN' })).signals.us_privacy).isEqualTo('disabled');
- name: '[CMP OneTrust] Reads the targeting category from OptanonConsent'
  code: |-
    [
      { cookie: 'isGpcEnabled=0&datestamp=x&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A0', expected: 'opt_out' },
      { cookie: 'isGpcEnabled=0&groups=C0001:1,C0004:1&geolocation=US;CA', expected: 'no_opt_out' },
      { cookie: 'groups=C0001:1,C0002:0', expected: 'unknown' },
      { cookie: 'datestamp=x', expected: 'unknown' },
      { cookie: 'groups=C0001:1,C0005:0', category: 'C0005', expected: 'opt_out' },
      { cookie: 'isGpcEnabled=1&browserGpcFlag=1&groups=C0001%3A1%2CC0004%3A1', expected: 'opt_out', browserGpc: true },
      { cookie: 'browserGpcFlag=1&datestamp=x', expected: 'opt_out', browserGpc: true },
      { cookie: 'isGpcEnabled=1&browserGpcFlag=0&groups=C0004:1', expected: 'no_opt_out' },
      { cookie: undefined, expected: 'unknown', missing: true }
    ].forEach((scenario) => {
      setRequest({ cookies: { OptanonConsent: scenario.cookie } });

      const result = runCode(
        createMockData({ enableCmp: true, cmpPreset: 'onetrust', oneTrustCategory: scenario.category })
      );

      assertThat(result.signals.cmp).isEqualTo(scenario.expected);
      assertThat(result.details.cmp.cookie_found).isEqualTo(!scenario.missing);
      if (!scenario.missing) assertThat(result.details.cmp.browser_gpc).isEqualTo(scenario.browserGpc === true);
      assertThat(result.restricted).isEqualTo(scenario.expected === 'opt_out');
    });
- name: '[CMP Cookiebot] Reads the marketing flag from CookieConsent'
  code: |-
    [
      { cookie: "{stamp:'abc',necessary:true,preferences:true,statistics:true,marketing:false,method:'explicit',ver:1}", expected: 'opt_out' },
      { cookie: '{stamp:%27abc%27%2Cnecessary:true%2Cmarketing:true}', expected: 'no_opt_out' },
      { cookie: '{"necessary": true, "marketing": false}', expected: 'opt_out' },
      { cookie: '-1', expected: 'unknown' },
      { cookie: undefined, expected: 'unknown' }
    ].forEach((scenario) => {
      setRequest({ cookies: { CookieConsent: scenario.cookie } });

      const result = runCode(createMockData({ enableCmp: true, cmpPreset: 'cookiebot' }));

      assertThat(result.signals.cmp).isEqualTo(scenario.expected);
      assertThat(result.details.cmp.preset).isEqualTo('cookiebot');
    });
- name: '[CMP TrustArc] Reads notice_gdpr_prefs first, then notice_preferences'
  code: |-
    [
      { cookies: { notice_gdpr_prefs: '0,1:', notice_preferences: '2:' }, expected: 'opt_out', cookie: 'notice_gdpr_prefs' },
      { cookies: { notice_gdpr_prefs: '0,1,2:' }, expected: 'no_opt_out', cookie: 'notice_gdpr_prefs' },
      { cookies: { notice_preferences: '1:' }, expected: 'opt_out', cookie: 'notice_preferences' },
      { cookies: { notice_preferences: '2:' }, expected: 'no_opt_out', cookie: 'notice_preferences' },
      { cookies: { notice_preferences: 'abc:' }, expected: 'unknown', cookie: 'notice_preferences' },
      { cookies: { notice_gdpr_prefs: '0,1,12:' }, expected: 'opt_out', cookie: 'notice_gdpr_prefs' },
      { cookies: { notice_gdpr_prefs: '100:' }, expected: 'unknown', cookie: 'notice_gdpr_prefs' },
      { cookies: { notice_gdpr_prefs: 'abc:' }, expected: 'unknown', cookie: 'notice_gdpr_prefs' },
      { cookies: { notice_preferences: '100:' }, expected: 'unknown', cookie: 'notice_preferences' },
      { cookies: { notice_preferences: '3:' }, expected: 'no_opt_out', cookie: 'notice_preferences' },
      { cookies: { notice_preferences: '1:' }, category: '1', expected: 'no_opt_out', cookie: 'notice_preferences' },
      { cookies: {}, expected: 'unknown', cookie: undefined }
    ].forEach((scenario) => {
      setRequest({ cookies: scenario.cookies });

      const result = runCode(
        createMockData({ enableCmp: true, cmpPreset: 'trustarc', trustArcCategory: scenario.category })
      );

      assertThat(result.signals.cmp).isEqualTo(scenario.expected);
      assertThat(result.details.cmp.cookie).isEqualTo(scenario.cookie);
    });
- name: '[CMP Custom] Matches the cookie value with equals, contains and regex'
  code: |-
    [
      { matchType: 'equals', cookie: 'optout', optOut: 'optout', optIn: 'optin', expected: 'opt_out' },
      { matchType: 'equals', cookie: 'optin', optOut: 'optout', optIn: 'optin', expected: 'no_opt_out' },
      { matchType: 'equals', cookie: 'other', optOut: 'optout', optIn: 'optin', expected: 'unknown' },
      { matchType: 'contains', cookie: 'sale=0|share=0', optOut: 'sale=0', expected: 'opt_out' },
      { matchType: 'regex', cookie: 'Marketing=DENIED', optOut: 'marketing=(denied|0)', expected: 'opt_out' },
      { matchType: 'regex', cookie: 'marketing=granted', optOut: 'marketing=(denied|0)', optIn: 'granted$', expected: 'no_opt_out' },
      { matchType: 'equals', cookie: undefined, optOut: 'optout', expected: 'unknown', missing: true }
    ].forEach((scenario) => {
      setRequest({ cookies: { my_consent: scenario.cookie } });

      const result = runCode(
        createMockData({
          enableCmp: true,
          cmpPreset: 'custom',
          cmpCustomCookieName: 'my_consent',
          cmpCustomMatchType: scenario.matchType,
          cmpCustomOptOutValue: scenario.optOut,
          cmpCustomOptInValue: scenario.optIn
        })
      );

      assertThat(result.signals.cmp).isEqualTo(scenario.expected);
      assertThat(result.details.cmp.cookie_found).isEqualTo(!scenario.missing);
    });

    const result = runCode(createMockData({ enableCmp: true, cmpPreset: 'custom' }));
    assertThat(result.details.cmp).isEqualTo({ status: 'unknown', preset: 'custom', cookie_found: false });
- name: '[Consent Mode] Reads consent_state, x-ga-gcs, npa and rdp'
  code: |-
    [
      { eventData: { consent_state: { ad_storage: false, ad_user_data: true } }, expected: 'opt_out', source: 'consent_state' },
      { eventData: { consent_state: { ad_storage: true, ad_user_data: false } }, expected: 'opt_out', source: 'consent_state' },
      { eventData: { consent_state: { ad_storage: true }, 'x-ga-gcs': 'G100' }, expected: 'no_opt_out', source: 'consent_state' },
      { eventData: { 'x-ga-gcs': 'G100' }, expected: 'opt_out', source: 'x-ga-gcs' },
      { eventData: { 'x-ga-gcs': 'G111' }, expected: 'no_opt_out', source: 'x-ga-gcs' },
      { eventData: { 'x-ga-gcs': 'G1--' }, expected: 'unknown', source: undefined },
      { eventData: { 'x-ga-gcs': 'G111', 'x-ga-npa': '1' }, expected: 'no_opt_out', source: 'x-ga-gcs' },
      { eventData: { 'x-ga-gcs': 'G111', 'x-ga-npa': '1' }, npa: true, expected: 'opt_out', source: 'x-ga-npa' },
      { eventData: { 'x-ga-npa': '0' }, npa: true, expected: 'unknown', source: undefined },
      { eventData: { 'x-sst-system_properties': { rdp: true } }, rdp: true, expected: 'opt_out', source: 'x-sst-system_properties.rdp' },
      { eventData: { 'x-sst-system_properties': { rdp: false } }, rdp: true, expected: 'unknown', source: undefined }
    ].forEach((scenario) => {
      setRequest({ eventData: usEventData(scenario.eventData) });

      const result = runCode(
        createMockData({ enableConsentMode: true, consentModeUseNpa: scenario.npa, consentModeUseRdp: scenario.rdp })
      );

      assertThat(result.signals.consent_mode).isEqualTo(scenario.expected);
      assertThat(result.details.consent_mode.source).isEqualTo(scenario.source);
    });
- name: '[Resolution] Any opt-out wins and the priority order picks the reason'
  code: |-
    setRequest({
      headers: { 'sec-gpc': '1' },
      cookies: { OptanonConsent: 'groups=C0004:0' },
      eventData: usEventData({ 'x-sst-system_properties': { us_privacy: '1YNN' } })
    });

    let result = runCode(createMockData({ enableCmp: true, cmpPreset: 'onetrust' }));
    assertThat(result.decision).isEqualTo('limited');
    assertThat(result.reason).isEqualTo('gpc');

    result = runCode(
      createMockData({
        enableCmp: true,
        cmpPreset: 'onetrust',
        signalPriority: [{ signal: 'us_privacy' }, { signal: 'cmp' }, { signal: 'gpc' }]
      })
    );
    assertThat(result.decision).isEqualTo('limited');
    assertThat(result.reason).isEqualTo('cmp');
- name: '[Resolution] First signal with a clear answer wins in priority mode'
  code: |-
    setRequest({
      headers: { 'sec-gpc': '1' },
      cookies: { OptanonConsent: 'groups=C0004:1' }
    });

    let result = runCode(
      createMockData({
        resolutionMode: 'priority',
        enableCmp: true,
        cmpPreset: 'onetrust',
        signalPriority: [{ signal: 'cmp' }, { signal: 'gpc' }]
      })
    );
    assertThat(result.decision).isEqualTo('allow');
    assertThat(result.opted_out).isFalse();
    assertThat(result.reason).isEqualTo('cmp');

    result = runCode(createMockData({ resolutionMode: 'priority', enableCmp: true, cmpPreset: 'onetrust' }));
    assertThat(result.decision).isEqualTo('limited');
    assertThat(result.reason).isEqualTo('gpc');

    setRequest({ cookies: { OptanonConsent: 'groups=C0002:1' } });
    result = runCode(createMockData({ resolutionMode: 'priority', enableCmp: true, cmpPreset: 'onetrust' }));
    assertThat(result.decision).isEqualTo('allow');
    assertThat(result.reason).isEqualTo('no_opt_out_signal');
- name: '[Resolution] Priority table ignores invalid and duplicate rows and appends missing signals'
  code: |-
    setRequest({
      headers: { 'sec-gpc': '1' },
      eventData: usEventData({ 'x-sst-system_properties': { us_privacy: '1YYN' } })
    });

    const result = runCode(
      createMockData({
        signalPriority: [{ signal: 'bogus' }, {}, { signal: 'us_privacy' }, { signal: 'us_privacy' }]
      })
    );
    assertThat(result.reason).isEqualTo('us_privacy');

    const fallbackResult = runCode(createMockData({ signalPriority: 'not a table' }));
    assertThat(fallbackResult.reason).isEqualTo('gpc');
- name: '[Resolution] Fail closed treats visitors without a clear signal as opted out'
  code: |-
    [
      { request: {}, overrides: {}, decision: 'allow', reason: 'no_opt_out_signal', optedOut: false },
      { request: {}, overrides: { noSignalBehavior: 'optOut' }, decision: 'limited', reason: 'no_clear_signal', optedOut: true },
      {
        request: { eventData: usEventData({ 'x-sst-system_properties': { gpp: 'garbage!' } }) },
        overrides: { noSignalBehavior: 'optOut', optOutAction: 'block' },
        decision: 'block',
        reason: 'no_clear_signal',
        optedOut: true
      },
      {
        request: { eventData: usEventData({ 'x-sst-system_properties': { us_privacy: '1YNN' } }) },
        overrides: { noSignalBehavior: 'optOut' },
        decision: 'allow',
        reason: 'no_opt_out_signal',
        optedOut: false
      },
      {
        request: { cookies: { OptanonConsent: 'groups=C0004:1' } },
        overrides: { noSignalBehavior: 'optOut', resolutionMode: 'priority', enableCmp: true, cmpPreset: 'onetrust' },
        decision: 'allow',
        reason: 'cmp',
        optedOut: false
      },
      {
        request: { headers: { 'sec-gpc': '1' } },
        overrides: { noSignalBehavior: 'optOut' },
        decision: 'limited',
        reason: 'gpc',
        optedOut: true
      },
      {
        request: { eventData: { event_location: { country: 'BR', region: 'SP' } } },
        overrides: { noSignalBehavior: 'optOut' },
        decision: 'allow',
        reason: 'region_not_applicable',
        optedOut: true
      }
    ].forEach((scenario) => {
      setRequest(scenario.request);

      const result = runCode(createMockData(scenario.overrides));

      assertThat(result.decision).isEqualTo(scenario.decision);
      assertThat(result.reason).isEqualTo(scenario.reason);
      assertThat(result.opted_out).isEqualTo(scenario.optedOut);
    });
- name: '[Decision] Block action returns block with restricted vendor flags'
  code: |-
    setRequest({ headers: { 'sec-gpc': '1' } });

    const mockData = createMockData({ optOutAction: 'block', returnType: 'decision' });
    assertThat(runCode(mockData)).isEqualTo('block');

    mockData.returnType = 'object';
    const result = runCode(mockData);
    assertThat(result.restricted).isTrue();
    assertThat(result.vendor.tiktok.limited_data_use).isTrue();
- name: '[Region] All US scope skips non US traffic'
  code: |-
    setRequest({
      headers: { 'sec-gpc': '1' },
      eventData: { event_location: { country: 'BR', region: 'SP' } }
    });

    const result = runCode(createMockData({}));

    assertThat(result.decision).isEqualTo('allow');
    assertThat(result.opted_out).isTrue();
    assertThat(result.applies).isFalse();
    assertThat(result.reason).isEqualTo('region_not_applicable');
    assertThat(result.country).isEqualTo('BR');
    assertThat(result.region).isEqualTo('SP');
    assertThat(result.vendor.meta.data_processing_options).isEqualTo([]);

    const everywhere = runCode(createMockData({ regionScope: 'everywhere' }));
    assertThat(everywhere.decision).isEqualTo('limited');
    assertThat(everywhere.applies).isTrue();
- name: '[Region] Selected states and unknown location behavior'
  code: |-
    [
      { location: { country: 'US', region: 'CA' }, scope: 'states', expected: true },
      { location: { country: 'US', region: 'NY' }, scope: 'states', expected: false },
      { location: { country: 'US', region: 'NY' }, scope: 'states', states: 'ny, nj', expected: true },
      { location: { country: 'US' }, scope: 'states', expected: true },
      { location: { country: 'US' }, scope: 'states', unknown: 'skip', expected: false },
      { location: undefined, scope: 'us', expected: true },
      { location: undefined, scope: 'us', unknown: 'skip', expected: false },
      { location: { country: 'CA', region: 'QC' }, scope: 'states', expected: false }
    ].forEach((scenario) => {
      setRequest({ headers: { 'sec-gpc': '1' }, eventData: { event_location: scenario.location } });

      const overrides = { regionScope: scenario.scope, unknownGeoBehavior: scenario.unknown || 'apply' };
      if (scenario.states) overrides.regionStates = scenario.states;
      const result = runCode(createMockData(overrides));

      assertThat(result.applies).isEqualTo(scenario.expected);
      assertThat(result.decision).isEqualTo(scenario.expected ? 'limited' : 'allow');
    });
- name: '[Geo] Reads event_location, then geo headers, and normalizes values'
  code: |-
    [
      {
        request: { eventData: { event_location: { country: 'us', region: 'ca' } }, headers: { 'x-geo-country': 'BR' } },
        expected: { country: 'US', region: 'CA', source: 'event_location' }
      },
      {
        request: { eventData: { event_location: { country: 'US' } } },
        expected: { country: 'US', region: undefined, source: 'event_location' }
      },
      {
        request: { eventData: { event_location: { country: 'XX' } }, headers: { 'x-geo-country': 'US', 'x-geo-region': 'California' } },
        expected: { country: 'US', region: 'CA', source: 'x-geo' }
      },
      {
        request: { eventData: {}, headers: { 'x-geo-country': 'US', 'x-geo-region': 'New York' } },
        expected: { country: 'US', region: 'NY', source: 'x-geo' }
      },
      {
        request: { eventData: {}, headers: { 'x-geo-country': 'ZZ', 'x-gclb-country': 'US', 'x-gclb-region': 'USTX' } },
        expected: { country: 'US', region: 'TX', source: 'x-gclb' }
      },
      {
        request: { eventData: {}, headers: { 'x-geo-country': 'DE', 'x-geo-region': 'Bavaria' } },
        expected: { country: 'DE', region: 'BAVARIA', source: 'x-geo' }
      },
      {
        request: { eventData: {}, headers: { 'cf-ipcountry': 'US' } },
        expected: { country: 'US', region: undefined, source: 'cf' }
      },
      {
        request: { eventData: {}, headers: { 'cf-ipcountry': 'USA' } },
        expected: { country: undefined, region: undefined, source: 'none' }
      }
    ].forEach((scenario) => {
      setRequest(scenario.request);

      const result = runCode(createMockData({}));

      assertThat(result.country).isEqualTo(scenario.expected.country);
      assertThat(result.region).isEqualTo(scenario.expected.region);
      assertThat(result.geo_source).isEqualTo(scenario.expected.source);
    });
- name: '[Geo] Custom variables override automatic detection'
  code: |-
    setRequest({ eventData: { event_location: { country: 'BR', region: 'SP' } } });

    [
      { country: 'us', region: 'US-TX', expected: { country: 'US', region: 'TX' } },
      { country: 'US', region: 'texas', expected: { country: 'US', region: 'TX' } },
      { country: '', region: 'CA', expected: { country: undefined, region: 'CA' } }
    ].forEach((scenario) => {
      const result = runCode(
        createMockData({ geoSource: 'custom', customCountry: scenario.country, customRegion: scenario.region })
      );

      assertThat(result.country).isEqualTo(scenario.expected.country);
      assertThat(result.region).isEqualTo(scenario.expected.region);
      assertThat(result.geo_source).isEqualTo('custom');
    });
- name: '[Return Types] Each return type returns the matching value'
  code: |-
    [
      { gpc: '1', returnType: 'decision', expected: 'limited' },
      { gpc: undefined, returnType: 'decision', expected: 'allow' },
      { gpc: '1', returnType: 'restricted', expected: true },
      { gpc: undefined, returnType: 'restricted', expected: false },
      { gpc: '1', returnType: 'metaDpo', expected: ['LDU'] },
      { gpc: undefined, returnType: 'metaDpo', expected: [] },
      { gpc: '1', returnType: 'metaDpoCountry', expected: 0 },
      { gpc: undefined, returnType: 'metaDpoCountry', expected: undefined },
      { gpc: '1', returnType: 'metaDpoState', expected: 0 },
      { gpc: undefined, returnType: 'metaDpoState', expected: undefined },
      { gpc: '1', returnType: 'googleAdsRdp', expected: true },
      { gpc: undefined, returnType: 'googleAdsRdp', expected: false },
      { gpc: '1', returnType: 'tiktokLdu', expected: true },
      { gpc: undefined, returnType: 'tiktokLdu', expected: false }
    ].forEach((scenario) => {
      setRequest({ headers: { 'sec-gpc': scenario.gpc } });

      assertThat(runCode(createMockData({ returnType: scenario.returnType }))).isEqualTo(scenario.expected);
    });
- name: '[Meta] United States mode sets country 1 and state 1000 only for California'
  code: |-
    [
      { region: 'CA', state: 1000 },
      { region: 'CO', state: 0 },
      { region: undefined, state: 0 }
    ].forEach((scenario) => {
      setRequest({ headers: { 'sec-gpc': '1' }, eventData: { event_location: { country: 'US', region: scenario.region } } });

      const meta = runCode(createMockData({ metaDpoMode: 'us' })).vendor.meta;

      assertThat(meta.data_processing_options).isEqualTo(['LDU']);
      assertThat(meta.data_processing_options_country).isEqualTo(1);
      assertThat(meta.data_processing_options_state).isEqualTo(scenario.state);
    });
setup: |-
  const Object = require('Object');

  const fixtures = {
    usnatSaleOptOut: 'DBABL~BEAaAAAAAAA',
    usnatNoOptOut: 'DBABL~BAAqAAAAAAA',
    usnatTargetedOptOut: 'DBABL~CAApAAAAAAA',
    usnatGpcOnly: 'DBABL~BAAqAAAAAAA.Y',
    usnatGpcFalse: 'DBABL~BAAqAAAAAAA.Q',
    usnatNotApplicable: 'DBABL~BAAAAAAAAAA',
    usnatV3: 'DBABL~DAAQAAAAAAA',
    uscaSharingOptOut: 'DBABBg~BAkAAAAA',
    usvaSaleOptOut: 'DBABRg~BAYAAAA',
    uscoTargetedOptOut: 'DBABJg~BAkAAAA',
    usutSaleOptOut: 'DBABFg~BAGAAAA',
    usctNoOptOut: 'DBABVg~BAoAAAA',
    multiTcfUsnatUsca: 'DBADMNg~CPXxRfAPXxRfAAfKABENB-CgAAAAAAAAAAYgAAAAAAAA~BAAqAAAAAAA~BAYAAAAA',
    multiRanges: 'DBABrY~BAAqAAAAAAA~BAoAAAAA~BAYAAAA',
    uspv1: 'DBABT~1YYN',
    unsupportedFlorida: 'DBABAw~BAAAAAA',
    officialUsnatGpc: 'DBABLA~CEAqAAAAAABA.YA',
    officialUscaSaleOptOut: 'DBABBg~BAYAAABA.QA',
    officialMultiNoOptOut: 'DBACzzA~1YNN~CAAqAAAAAABA.QA~BAoAABA'
  };

  const assign = (target, source) => {
    Object.keys(source || {}).forEach((key) => {
      target[key] = source[key];
    });
    return target;
  };

  const createMockData = (overrides) => {
    return assign(
      {
        returnType: 'object',
        optOutAction: 'limited',
        resolutionMode: 'anyOptOut',
        noSignalBehavior: 'allow',
        signalPriority: [
          { signal: 'gpc' },
          { signal: 'gpp' },
          { signal: 'us_privacy' },
          { signal: 'cmp' },
          { signal: 'consent_mode' }
        ],
        enableGpc: true,
        enableGpp: true,
        enableUsPrivacy: true,
        enableCmp: false,
        enableConsentMode: false,
        regionScope: 'us',
        regionStates: 'CA,CO,CT,DE,FL,IA,IN,KY,MD,MN,MT,NE,NH,NJ,OR,RI,TN,TX,UT,VA',
        unknownGeoBehavior: 'apply',
        geoSource: 'auto',
        metaDpoMode: 'geolocation'
      },
      overrides
    );
  };

  const usEventData = (extra) => {
    return assign({ event_name: 'page_view', event_location: { country: 'US', region: 'CA' } }, extra);
  };

  const setRequest = (request) => {
    const eventData = request.eventData === undefined ? usEventData({}) : request.eventData;
    const headers = request.headers || {};
    const cookies = request.cookies || {};
    mock('getAllEventData', () => eventData);
    mock('getRequestHeader', (name) => headers[name.toLowerCase()]);
    mock('getCookieValues', (name) => (cookies[name] === undefined ? [] : [cookies[name]]));
  };

  setRequest({});


___NOTES___

2026-11-17 - Change Notes:
  - First release

Created on 11/17/2026, 17:02:22


