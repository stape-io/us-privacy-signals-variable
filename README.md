# US Privacy Signals Variable for Google Tag Manager Server-Side

The **US Privacy Signals variable for the Google Tag Manager server container** combines US opt-out signals and the visitor's location into one decision: `allow`, `limited` or `block`. It also returns ready-made values for the limited data use settings of Meta, Google Ads and TikTok.

US privacy laws (CCPA/CPRA and the other state laws) follow an opt-out model: you must honor a "Do Not Sell or Share" choice and the Global Privacy Control (GPC) signal. Google Consent Mode often stays "granted" for US visitors, so it does not reflect these choices on its own. This variable reads them in the server container, the last point before data leaves for the vendors.

> This variable is a technical tool, not legal advice. Confirm your own legal requirements.

## Features

- **Global Privacy Control**: reads the `Sec-GPC` request header that browsers with GPC turned on send with every request, with the GPC flag in the GA4 `gcd` parameter as a fallback.
- **IAB Global Privacy Platform (GPP)**: decodes the GPP string that the Google tag forwards from the CMP. Supported sections are US National (7, versions 1 and 2) and all the state sections from 8 to 27 (California, Virginia, Colorado, Utah, Connecticut, Florida, Montana, Oregon, Texas, Delaware, Iowa, Nebraska, New Hampshire, New Jersey, Tennessee, Minnesota, Maryland, Indiana, Kentucky and Rhode Island), including their GPC sub-sections, plus the legacy US Privacy section (6). The applicable section IDs (`gpp_sid`) limit which sections are evaluated.
- **IAB US Privacy string** (`us_privacy`, for example `1YYN`): read from Event Data or from the `usprivacy` / `us_privacy` cookies.
- **CMP cookies**: presets for OneTrust (`OptanonConsent`, including its `browserGpcFlag`), Cookiebot (`CookieConsent`) and TrustArc (`notice_gdpr_prefs` / `notice_preferences`), plus a custom cookie with equals, contains or regex matching.
- **Google Consent Mode**: Data Tag `consent_state`, or the GA4 `gcd` / `gcs` parameters. `ad_storage`, `ad_user_data` or `ad_personalization` denied is an opt-out. Optionally, `npa=1` and restricted data processing set on the website count as opt-outs.
- **Region rules**: apply the opt-out logic to all US traffic, to selected states, or everywhere.
- **Two resolution modes**: *Any opt-out wins* (default) or *First signal with a clear answer wins*, both following a configurable priority order.
- **Optional fail-closed mode**: treat visitors as opted out when no signal gives a clear answer, so a missing or unreadable signal restricts data instead of letting it through.
- **Vendor flags**: Meta `data_processing_options` / `_country` / `_state`, Google Ads restricted data processing and TikTok `limited_data_use`.

## How to use the US Privacy Signals variable

1. Add the **US Privacy Signals** variable to your server GTM container.
2. Choose the **Return Type**. Create one variable per value you need, for example one for the decision and one for each vendor flag.
3. Under **Decision**, choose the value the Decision returns when the visitor opted out (`limited` or `block`, see [Limited or block](#limited-or-block)), what happens when no signal gives a clear answer (see [Fail-closed mode](#fail-closed-mode)), and how disagreeing signals are resolved. The signal priority table is shown in the *First signal with a clear answer wins* mode, and for the Full object return type, where it picks the signal reported as the `reason`.
4. Under **Signals**, enable the signals you use. GPC, GPP and US Privacy are on by default. If you enable **CMP cookie**, choose your CMP.
5. Under **Region Rules**, choose where the opt-out logic applies and where the visitor location comes from (see [Visitor location](#visitor-location)).
6. For the Meta country and state return types, and the Full object, choose the values under **Meta Limited Data Use**. Those settings are hidden for the other return types.
7. Use the variables in your tags and triggers (see below).

### Return types

| Return type | Not restricted | Restricted (`limited` or `block`) |
|---|---|---|
| Decision | `allow` | `limited` or `block`, whichever is set in **Decision value when the visitor opted out** |
| Restricted | `false` | `true` |
| Full object | see below | see below |
| Meta - data_processing_options | `[]` | `['LDU']` |
| Meta - data_processing_options_country | `undefined` | `0`, or `1` in United States mode |
| Meta - data_processing_options_state | `undefined` | `0`, or the Meta state code in United States mode (see [Meta state codes](#meta-state-codes)) |
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
  "details": { "gpc": { "status": "opt_out", "value": "1", "source": "sec-gpc" }, "gpp": { "status": "no_opt_out", "sections": [] } },
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

### Limited or block

**Decision value when the visitor opted out** sets the word the Decision returns for an opted-out visitor inside the region rules. A variable returns either `allow` or that word, never both `limited` and `block`. The setting is shown only for the Decision and Full object return types, because the other return types are the same for both values.

The variable does not stop or change tags. The value tells your container which approach you take:

- `limited`: the events are still sent, with limited data use flags. Map the Meta, Google Ads and TikTok return types into your tags.
- `block`: the events are not sent. Use `Decision equals block` as an exception trigger on the tags that must not fire. Without that trigger, the tags still fire.

### Fail-closed mode

**When no signal gives a clear answer** controls what happens when no enabled signal reports either an opt-out or an explicit "did not opt out". This happens when there is no `Sec-GPC` header, the GPP string is missing or in a format the variable does not decode, the US Privacy string is missing or `1---`, or there is no CMP cookie.

- **Treat as not opted out (allow)** (default): the decision is `allow`, with the reason `no_opt_out_signal`.
- **Treat as opted out (fail closed)**: the visitor gets the opt-out action (`limited` or `block`), with the reason `no_clear_signal`.

Fail-closed protects against silent misses. If a signal stops arriving, for example because a CMP changes its cookie format or an Event Data key changes, visitors are restricted instead of allowed. An explicit "did not opt out" from any signal still allows the visitor, and the region rules apply first.

GPC can only report an opt-out, never "did not opt out". With GPC as the only enabled signal and fail-closed on, every visitor without GPC is restricted. With the **Custom cookie** CMP preset, fill in **Value that means not opted out**, otherwise the cookie can never report "did not opt out" either. Google Consent Mode only reports "did not opt out" when **What Google Consent Mode can report** is set to **Opt-out and did not opt out** (see [Google Consent Mode](#google-consent-mode)).

### Meta state codes

With **Country and state values when restricted** set to **United States**, `data_processing_options_country` is `1` and `data_processing_options_state` is Meta's code for the visitor's state. The codes are `1000` California, `1001` Colorado, `1002` Connecticut, `1003` Florida, `1004` Oregon, `1005` Texas, `1006` Montana, `1007` Delaware, `1008` Nebraska, `1009` New Hampshire, `1010` New Jersey, `1011` Minnesota, `1012` Maryland and `1013` Rhode Island.

Other states, and visitors outside the US, get `0`, which lets Meta geolocate the state. Use this mode only with US-only region rules, because the country is always `1`. The default, **Let Meta geolocate**, returns `0` for both.

### Using the output in tags

- **Meta Conversions API tag**: in **Server Event Data Override**, map `data_processing_options`, `data_processing_options_country` and `data_processing_options_state` to the three Meta return types.
- **Blocking tags**: use the **Decision** variable in a trigger condition, for example `Decision equals block` as an exception trigger.
- **Other tags**: map the Google Ads and TikTok return types to the matching tag settings where the tag accepts a variable.

### Evaluating the variable once per event with a Transformation

Every reference to a variable runs it again. A Meta tag that maps the three Meta return types, a Google Ads tag and a blocking trigger together run the variable's logic five or more times for the same event.

To compute the result once per event and share it, add it to the event with a Transformation and read it with Event Data variables:

1. Create one **US Privacy Signals** variable with the return type **Full object**, for example `US Privacy - Object`.
2. Create a Transformation of type **Augment event**:
   - **Parameters to augment**: Name `us_privacy`, Value `{{US Privacy - Object}}`.
   - **Affected tags**: all tags, or only the tags that use the result.
3. Create **Event Data** variables that read parts of the result:

   | Variable | Key Path |
   |---|---|
   | `US Privacy - Decision` | `us_privacy.decision` |
   | `US Privacy - Restricted` | `us_privacy.restricted` |
   | `US Privacy - Meta DPO` | `us_privacy.vendor.meta.data_processing_options` |
   | `US Privacy - Meta DPO Country` | `us_privacy.vendor.meta.data_processing_options_country` |
   | `US Privacy - Meta DPO State` | `us_privacy.vendor.meta.data_processing_options_state` |
   | `US Privacy - Google Ads RDP` | `us_privacy.vendor.google_ads.restricted_data_processing` |
   | `US Privacy - TikTok LDU` | `us_privacy.vendor.tiktok.limited_data_use` |

4. Use these Event Data variables in tags and triggers in place of separate US Privacy Signals variables. For example, map the three Meta variables in the Meta Conversions API tag's **Server Event Data Override**, and use `US Privacy - Decision equals block` as an exception trigger.

The Transformation evaluates the variable once for the event, and every affected tag reads the same result. Triggers of affected tags see the added `us_privacy` key too, so trigger conditions can use the Event Data variables. Values keep their types: `data_processing_options` stays an array.

In Preview, open a fired tag: **Tag Details** lists the Transformations applied to it, and the **Event Data** tab shows `us_privacy`.

### Where the signals come from

| Signal | Source |
|---|---|
| GPC | `Sec-GPC` request header. Make sure your CDN or proxy forwards it. When the header is missing, the GPC flag in Event Data `x-ga-gcd` is used. The Google tag only sets that flag in the regions where it honors GPC. |
| GPP | Event Data `x-sst-system_properties.gpp` / `.gpp_sid` (sent by the Google tag as `sst.gpp` / `sst.gpp_sid`), then `x-ads-gpp` / `x-ads-gpp_sid`, then the `OTGPPConsent` cookie that OneTrust writes when GPP is configured, or a variable |
| US Privacy | Event Data `x-sst-system_properties.us_privacy`, then `x-ads-us_privacy`, then the `usprivacy` and `us_privacy` cookies, or a variable |
| CMP | First-party CMP cookie. It only reaches the server container when the container runs on a subdomain of your website. For OneTrust, `browserGpcFlag=1` in `OptanonConsent` (the browser had GPC turned on) also counts as an opt-out, which covers setups where a proxy strips the `Sec-GPC` header. |
| Google Consent Mode | Event Data `consent_state` (Data Tag), then `x-ga-gcd`, then `x-ga-gcs`, plus optionally `x-ga-npa` and `x-sst-system_properties.rdp` |

In GPP, a section counts as an opt-out when its Sale, Sharing or Targeted Advertising opt-out field is `1` (Opted Out), or when its GPC sub-section is set. A value of `2` (Did Not Opt Out) counts as no opt-out.

### Google Consent Mode

The variable uses the first of these sources that gives an answer:

1. The Data Tag's `consent_state`.
2. The GA4 `gcd` parameter (`x-ga-gcd`). It carries the default and update state of each consent type. The update is used when it is set, otherwise the default.
3. The GA4 `gcs` parameter (`x-ga-gcs`), which only carries `ad_storage`.

`ad_storage`, `ad_user_data` or `ad_personalization` denied is an opt-out. `ad_storage` granted depends on **What Google Consent Mode can report**:

- **Opt-out only (granted counts as unknown)** (default): many US websites set `ad_storage` to granted by default, so granted does not show that the visitor made a choice. Google Consent Mode then never overrides another signal or fail-closed mode.
- **Opt-out and did not opt out**: granted counts as an explicit "did not opt out". It can decide the result in the *First signal with a clear answer wins* mode, and it keeps fail-closed mode from treating the visitor as opted out.

The Full object shows the source and the state of each consent type in `details.consent_mode`.

### Visitor location

The location is read even when the opt-out logic applies to all traffic, because the Meta **United States** mode ([state codes](#meta-state-codes)) and the Full object also use it.

With the **Automatic** source, country and region are read together from the first source that has a country:

1. Event Data `event_location` (the Google tag sends it as the `ur` parameter, for example `US-CA`).
2. [Stape GEO Headers power-up](https://stape.io/helpdesk/documentation/geo-headers-power-up): `X-GEO-Country` / `X-GEO-Region`.
3. Google Cloud load balancer: `X-Gclb-Country` / `X-Gclb-Region`.
4. AWS CloudFront: `CloudFront-Viewer-Country` / `CloudFront-Viewer-Country-Region`.
5. Google App Engine: `X-AppEngine-Country` / `X-AppEngine-Region`.
6. Azure Front Door: `X-Azure-Country` (country only).
7. Cloudflare: `CF-IPCountry` (country only).

Most of these headers have to be turned on in your hosting or CDN setup. See [Enable region-specific settings](https://developers.google.com/tag-platform/tag-manager/server-side/enable-region-specific-settings) for how to add them on each provider.

Regions are normalized to a 2-letter state code (`CA`, `US-CA` and `California` all become `CA`). To provide them yourself, choose **Custom variables** and fill in the country and region fields shown under that option.

## Limitations

- **Usercentrics** stores consent in the browser's local storage, which the server cannot read. Use its GPP output, or write a cookie and use the **Custom cookie** preset.
- GPP US National version 3 and sections above 27 are reported as `unknown`.
- The Google tag only forwards GPP and US Privacy strings when the CMP exposes the `__gpp` / `__uspapi` APIs on the page.

## Useful resources

- [Global Privacy Control](https://globalprivacycontrol.org/)
- [IAB Global Privacy Platform](https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform)
- [Meta: Data Processing Options for US users](https://developers.facebook.com/docs/marketing-apis/data-processing-options)

## Credits

The idea for this variable was proposed by Swapnil Jaykar, Web Analytics Manager at Uplers, and was the winner of the Stape Relay 2026 GTM Templates Competition.

## Open Source

The **US Privacy Signals Variable** for GTM Server-Side is developed and maintained by the [Stape Team](https://stape.io/) under the Apache 2.0 license.
