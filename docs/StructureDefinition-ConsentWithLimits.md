# Consent with use of the Limits extension - John Moehrke Consent About AI v0.2.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Consent with use of the Limits extension**

## Resource Profile: Consent with use of the Limits extension 

| | |
| :--- | :--- |
| *Official URL*:http://johnmoehrke.github.io/ConsentAboutAI/StructureDefinition/ConsentWithLimits | *Version*:0.2.0 |
| Draft as of 2026-08-16 | *Computable Name*:ConsentWithLimits |
| *Other Identifiers:*OID:1.3.6.1.4.1.66281.2.1.42.1 | |

 
Consent profile that includes the use of the consent-provision-limit extension to express limits on the use of data for ML training. 

**Usages:**

* Examples for this Profile: [Consent/AllAiProvisions](Consent-AllAiProvisions.md) and [Consent/AllowMLtrainingOnDeIdentifiedData](Consent-AllowMLtrainingOnDeIdentifiedData.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/resource/johnmoehrke.ConsentAboutAI.example|current/StructureDefinition/StructureDefinition-ConsentWithLimits.json)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-ConsentWithLimits.csv), [Excel](StructureDefinition-ConsentWithLimits.xlsx), [Schematron](StructureDefinition-ConsentWithLimits.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "ConsentWithLimits",
  "url" : "http://johnmoehrke.github.io/ConsentAboutAI/StructureDefinition/ConsentWithLimits",
  "identifier" : [{
    "system" : "urn:ietf:rfc:3986",
    "value" : "urn:oid:1.3.6.1.4.1.66281.2.1.42.1"
  }],
  "version" : "0.2.0",
  "name" : "ConsentWithLimits",
  "title" : "Consent with use of the Limits extension",
  "status" : "draft",
  "date" : "2026-08-16T14:50:06-05:00",
  "publisher" : "John Moehrke (Moehrke Research LLC)",
  "contact" : [{
    "name" : "John Moehrke (Moehrke Research LLC)",
    "telecom" : [{
      "system" : "url",
      "value" : "http://healthcaresecprivacy.blogspot.com"
    },
    {
      "system" : "email",
      "value" : "JohnMoehrke@gmail.com"
    }]
  }],
  "description" : "Consent profile that includes the use of the consent-provision-limit extension to express limits on the use of data for ML training.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001"
    }]
  }],
  "fhirVersion" : "4.0.1",
  "mapping" : [{
    "identity" : "workflow",
    "uri" : "http://hl7.org/fhir/workflow",
    "name" : "Workflow Pattern"
  },
  {
    "identity" : "v2",
    "uri" : "http://hl7.org/v2",
    "name" : "HL7 v2 Mapping"
  },
  {
    "identity" : "rim",
    "uri" : "http://hl7.org/v3",
    "name" : "RIM Mapping"
  },
  {
    "identity" : "w5",
    "uri" : "http://hl7.org/fhir/fivews",
    "name" : "FiveWs Pattern Mapping"
  }],
  "kind" : "resource",
  "abstract" : false,
  "type" : "Consent",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Consent",
  "derivation" : "constraint",
  "differential" : {
    "element" : [{
      "id" : "Consent",
      "path" : "Consent"
    },
    {
      "id" : "Consent.provision.modifierExtension",
      "path" : "Consent.provision.modifierExtension",
      "slicing" : {
        "discriminator" : [{
          "type" : "value",
          "path" : "url"
        }],
        "ordered" : false,
        "rules" : "open"
      }
    },
    {
      "id" : "Consent.provision.modifierExtension:limit",
      "path" : "Consent.provision.modifierExtension",
      "sliceName" : "limit",
      "min" : 0,
      "max" : "*",
      "type" : [{
        "code" : "Extension",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/consent-provision-limit"]
      }]
    },
    {
      "id" : "Consent.provision.provision",
      "path" : "Consent.provision.provision",
      "type" : [{
        "code" : "BackboneElement"
      }]
    },
    {
      "id" : "Consent.provision.provision.modifierExtension",
      "path" : "Consent.provision.provision.modifierExtension",
      "slicing" : {
        "discriminator" : [{
          "type" : "value",
          "path" : "url"
        }],
        "ordered" : false,
        "rules" : "open"
      }
    },
    {
      "id" : "Consent.provision.provision.modifierExtension:limit",
      "path" : "Consent.provision.provision.modifierExtension",
      "sliceName" : "limit",
      "min" : 0,
      "max" : "*",
      "type" : [{
        "code" : "Extension",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/consent-provision-limit"]
      }]
    },
    {
      "id" : "Consent.provision.provision.provision",
      "path" : "Consent.provision.provision.provision",
      "type" : [{
        "code" : "BackboneElement"
      }]
    },
    {
      "id" : "Consent.provision.provision.provision.modifierExtension",
      "path" : "Consent.provision.provision.provision.modifierExtension",
      "slicing" : {
        "discriminator" : [{
          "type" : "value",
          "path" : "url"
        }],
        "ordered" : false,
        "rules" : "open"
      }
    },
    {
      "id" : "Consent.provision.provision.provision.modifierExtension:limit",
      "path" : "Consent.provision.provision.provision.modifierExtension",
      "sliceName" : "limit",
      "min" : 0,
      "max" : "*",
      "type" : [{
        "code" : "Extension",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/consent-provision-limit"]
      }]
    }]
  }
}

```
