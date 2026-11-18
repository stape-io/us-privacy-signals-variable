# US Privacy Signals Variable for Google Tag Manager Server-Side

The **US Privacy Signals variable for the Google Tag Manager server container** combines US opt-out signals and the visitor's location into one decision: `allow`, `limited` or `block`. It also returns ready-made values for the limited data use settings of Meta, Google Ads and TikTok.

US privacy laws (CCPA/CPRA and the other state laws) follow an opt-out model: you must honor a "Do Not Sell or Share" choice and the Global Privacy Control (GPC) signal. Google Consent Mode often stays "granted" for US visitors, so it does not reflect these choices on its own. This variable reads them in the server container, the last point before data leaves for the vendors.

> This variable is a technical tool, not legal advice. Confirm your own legal requirements.

## Features

- **Global Privacy Control**: reads the `Sec-GPC` request header that browsers with GPC turned on send with every request.
- **IAB Global Privacy Platform (GPP)**: decodes the GPP string that the Google tag forwards from the CMP. Supported sections are US National (7, versions 1 and 2), California (8), Virginia (9), Colorado (10), Utah (11) and Connecticut (12), including their GPC sub-sections, plus the legacy US Privacy section (6). The applicable section IDs (`gpp_sid`) limit which sections are evaluated.
- **IAB US Privacy string** (`us_privacy`, for example `1YYN`): read from Event Data or from the `usprivacy` / `us_privacy` cookies.
- **CMP cookies**: presets for OneTrust (`OptanonConsent`, including its `browserGpcFlag`), Cookiebot (`CookieConsent`) and TrustArc (`notice_gdpr_prefs` / `notice_preferences`), plus a custom cookie with equals, contains or regex matching.
- **Google Consent Mode**: Data Tag `consent_state` or GA4 `x-ga-gcs`. Optionally, `npa=1` and restricted data processing set on the website count as opt-outs.
- **Region rules**: apply the opt-out logic to all US traffic, to selected states, or everywhere.
- **Two resolution modes**: *Any opt-out wins* (default) or *First signal with a clear answer wins*, both following a configurable priority order.
- **Optional fail-closed mode**: treat visitors as opted out when no signal gives a clear answer, so a missing or unreadable signal restricts data instead of letting it through.
- **Vendor flags**: Meta `data_processing_options` / `_country` / `_state`, Google Ads restricted data processing and TikTok `limited_data_use`.

## How to use the US Privacy Signals variable

1. Add the **US Privacy Signals** variable to your server GTM container.
2. Choose the **Return Type**. Create one variable per value you need, for example one for the decision and one for each vendor flag.
3. Under **Decision**, choose what happens when the visitor opted out (**Limited** or **Block**), what happens when no signal gives a clear answer (see [Fail-closed mode](#fail-closed-mode)), and how disagreeing signals are resolved.
4. Under **Signals**, enable the signals you use. GPC, GPP and US Privacy are on by default. If you enable **CMP cookie**, choose your CMP.
5. Under **Region Rules**, choose where the opt-out logic applies.
6. Use the variables in your tags and triggers (see below).

### Return types

| Return type | Not restricted | Restricted (`limited` or `block`) |
|---|---|---|
| Decision | `allow` | `limited` or `block` |
| Restricted | `false` | `true` |
| Full object | see below | see below |
| Meta - data_processing_options | `[]` | `['LDU']` |
| Meta - data_processing_options_country | `undefined` | `0`, or `1` in United States mode |
| Meta - data_processing_options_state | `undefined` | `0`, or `1000` for California in United States mode |
| Google Ads - restricted data processing | `false` | `true` |
| TikTok - limited_data_use | `false` | `true` |

The **Full object** is useful in Preview, because it shows why a decision was made:

```json
{
  "decision": "limited",
  "restricted": true,
  "opted_out": true,
  "reason": "gpc",
  "applies": true,
  "country": "US",
  "region": "CA",
  "geo_source": "event_location",
  "signals": {
    "gpc": "opt_out",
    "gpp": "no_opt_out",
    "us_privacy": "unknown",
    "cmp": "disabled",
    "consent_mode": "disabled"
  },
  "details": { "gpc": { "status": "opt_out", "value": "1" }, "gpp": { "status": "no_opt_out", "sections": [] } },
  "vendor": {
    "meta": {
      "data_processing_options": ["LDU"],
      "data_processing_options_country": 0,
      "data_processing_options_state": 0
    },
    "google_ads": { "restricted_data_processing": true },
    "tiktok": { "limited_data_use": true }
  }
}
```

- `signals`: one status per signal: `opt_out`, `no_opt_out`, `unknown` or `disabled`.
- `reason`: why the decision was made:
  - a signal name (`gpc`, `gpp`, `us_privacy`, `cmp`, `consent_mode`): that signal decided the outcome.
  - `no_opt_out_signal`: no signal reported an opt-out, so the visitor is allowed.
  - `no_clear_signal`: no signal gave a clear answer and fail-closed mode treated the visitor as opted out.
  - `region_not_applicable`: the visitor is outside the configured region, so the decision is always `allow`.
- `opted_out`: whether the visitor is treated as opted out, even when the region rules do not apply.

### Fail-closed mode

**When no signal gives a clear answer** controls what happens when no enabled signal reports either an opt-out or an explicit "did not opt out". This happens when there is no `Sec-GPC` header, the GPP string is missing or in a format the variable does not decode, the US Privacy string is missing or `1---`, or there is no CMP cookie.

- **Treat as not opted out (allow)** (default): the decision is `allow`, with the reason `no_opt_out_signal`.
- **Treat as opted out (fail closed)**: the visitor gets the opt-out action (`limited` or `block`), with the reason `no_clear_signal`.

Fail-closed protects against silent misses. If a signal stops arriving, for example because a CMP changes its cookie format or an Event Data key changes, visitors are restricted instead of allowed. An explicit "did not opt out" from any signal still allows the visitor, and the region rules apply first.

GPC can only report an opt-out, never "did not opt out". With GPC as the only enabled signal and fail-closed on, every visitor without GPC is restricted.

### Using the output in tags

- **Meta Conversions API tag**: in **Server Event Data Override**, map `data_processing_options`, `data_processing_options_country` and `data_processing_options_state` to the three Meta return types.
- **Blocking tags**: use the **Decision** variable in a trigger condition, for example `Decision equals block` as an exception trigger.
- **Other tags**: map the Google Ads and TikTok return types to the matching tag settings where the tag accepts a variable.

### Where the signals come from

| Signal | Source |
|---|---|
| GPC | `Sec-GPC` request header. Make sure your CDN or proxy forwards it. |
| GPP | Event Data `x-sst-system_properties.gpp` / `.gpp_sid` (sent by the Google tag as `sst.gpp` / `sst.gpp_sid`), then `x-ads-gpp` / `x-ads-gpp_sid`, then the `OTGPPConsent` cookie that OneTrust writes when GPP is configured, or a variable |
| US Privacy | Event Data `x-sst-system_properties.us_privacy`, then `x-ads-us_privacy`, then the `usprivacy` and `us_privacy` cookies, or a variable |
| CMP | First-party CMP cookie. It only reaches the server container when the container runs on a subdomain of your website. For OneTrust, `browserGpcFlag=1` in `OptanonConsent` (the browser had GPC turned on) also counts as an opt-out, which covers setups where a proxy strips the `Sec-GPC` header. |
| Consent Mode | Event Data `consent_state` (Data Tag), then `x-ga-gcs`, plus optionally `x-ga-npa` and `x-sst-system_properties.rdp` |

In GPP, a section counts as an opt-out when its Sale, Sharing or Targeted Advertising opt-out field is `1` (Opted Out), or when its GPC sub-section is set. A value of `2` (Did Not Opt Out) counts as no opt-out.

### Visitor location

With the **Automatic** source, country and region are read together from the first source that has a country:

1. Event Data `event_location` (the Google tag sends it as the `ur` parameter, for example `US-CA`).
2. [Stape GEO Headers power-up](https://stape.io/helpdesk/documentation/geo-headers-power-up): `X-GEO-Country` / `X-GEO-Region`.
3. `X-Gclb-Country` / `X-Gclb-Region`.
4. `CF-IPCountry` (country only).

Regions are normalized to a 2-letter state code (`CA`, `US-CA` and `California` all become `CA`). You can also provide the country and region with your own variables.

## Limitations

- **Usercentrics** stores consent in the browser's local storage, which the server cannot read. Use its GPP output, or write a cookie and use the **Custom cookie** preset.
- GPP sections 13 to 27 (other US states) and US National version 3 are reported as `unknown`. Use the US National section or the GPC signal for them.
- The Google tag only forwards GPP and US Privacy strings when the CMP exposes the `__gpp` / `__uspapi` APIs on the page.

## Useful resources

- [Global Privacy Control](https://globalprivacycontrol.org/)
- [IAB Global Privacy Platform](https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform)
- [Meta: Data Processing Options for US users](https://developers.facebook.com/docs/marketing-apis/data-processing-options)

## Open Source

The **US Privacy Signals Variable** for GTM Server-Side is developed and maintained by the [Stape Team](https://stape.io/) under the Apache 2.0 license.
