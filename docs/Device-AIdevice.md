# AI Device - John Moehrke Consent About AI v0.2.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **AI Device**

## Example Device: AI Device

**identifier**: `http://example.org/ehr/client-ids`/goodhealth

**manufacturer**: Acme Devices, Inc

**type**: Artificial intelligence device

### Versions

| | |
| :--- | :--- |
| - | **Value** |
| * | 10.23-23423 |

**contact**: [http://example.org](http://example.org)



## Resource Content

```json
{
  "resourceType" : "Device",
  "id" : "AIdevice",
  "identifier" : [{
    "system" : "http://example.org/ehr/client-ids",
    "value" : "goodhealth"
  }],
  "manufacturer" : "Acme Devices, Inc",
  "type" : {
    "coding" : [{
      "system" : "http://snomed.info/sct",
      "code" : "736253002"
    }],
    "text" : "Artificial intelligence device"
  },
  "version" : [{
    "value" : "10.23-23423"
  }],
  "contact" : [{
    "system" : "url",
    "value" : "http://example.org"
  }]
}

```
