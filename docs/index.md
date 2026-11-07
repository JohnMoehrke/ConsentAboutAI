# Home - John Moehrke Consent About AI v0.2.0

* [**Table of Contents**](toc.md)
* **Home**

## Home

| | |
| :--- | :--- |
| *Official URL*:http://johnmoehrke.github.io/ConsentAboutAI/ImplementationGuide/johnmoehrke.ConsentAboutAI.example | *Version*:0.2.0 |
| Draft as of 2026-08-16 | *Computable Name*:JohnMoehrkeConsentAboutAI |
| *Other Identifiers:*OID:1.3.6.1.4.1.66281.2.1 | |

This is an experimental IG. The content is fully from the perspective of the author, and is not endorsed by HL7 or any other organization. It is intended to be a discussion starter, and to solicit feedback from the community.

Shows how a Consent resource can be used to express permit or deny use of AI for a given patient.

 This IG is founded on HL7 FHIR Revision 4.0.1 found at [http://hl7.org/fhir/R4/](http://hl7.org/fhir/R4/) 

### Scope

There are various use-cases where a Patient might consent or dissent to various uses of AI.

1. A patient might consent to use of AI for clinical decision support
1. A patient might deny use of their data for training of AI.
1. A patient might consent to use of their data in de-identified form for training of AI.

Given the Consent model, the Patient might be indicated in a Consent authorizing either

* Generically allowing or denying AI by PurposeOfUse
* Specifically allowing or denying a specific AI by referencing the Device resource for that AI.

A Consent is the healthcare organization's actionable record of the patient's decision. It should carry only rules that an access-control engine can evaluate and that the organization can actually enforce. The signed paperwork that captures the ceremony of the consent remains the authoritative legal record, and is referenced from the Consent.

### Resource Model

```
classDiagram
class Patient {
subject of the consent
}
class Consent {
status: active
scope: patient-privacy
category: Release of information
dateTime
policy.uri
provision.type: permit or deny
provision.purpose: MLTRAINING, TREATDS, TPO
provision.securityLabel
provision.actor.reference
provision.modifierExtension[limit]
}
class Device {
the specific AI system or model
type: Artificial intelligence device
manufacturer
version
}
class DocumentReference {
signed consent paperwork
type
date
content
}
class Organization {
organization capturing and enforcing the consent
}
class ProvisionLimit {
consent-provision-limit extension
control: DEID and other obligations
tag
element
}

Consent --> Patient : patient
Consent --> DocumentReference : sourceReference
Consent --> Organization : performer
Consent --> Device : provision.actor.reference
Consent --> ProvisionLimit : provision.modifierExtension
DocumentReference --> Patient : subject

```

### PurposeOfUse

The most clean method is to use the PurposeOfUse as the basis for the provision in the Consent. This allows the Consent to be independent of the specific AI system or model, and thus not require updates as new AI systems or models are developed. The PurposeOfUse can be used to indicate the reason for the AI access, such as `MLTRAINING` for training of AI, or `TREATDS` for clinical decision support.

Further we look to [PurposeOfUse Vocabulary](https://terminology.hl7.org/ValueSet-v3-PurposeOfUse.html) to indicate what the reason the AI is giving for accessing data. For example, the PurposeOfUse of `MLTRAINING` is defined for when an AI is looking to train on data. The PurposeOfUse of `TREATDS` is defined for when an AI is looking to provide clinical decision support, or `PMTDS` when AI is looking to provide analysis for payment decisions.

The use of PurposeOfUse does require that any accesses the AI does, or an agent feeding the AI, must use the given PurposeOfUse code when accessing data. This is a trust model that the AI or the agent feeding the AI will accurately indicate the PurposeOfUse when accessing data. However, this is a common trust model used in many other aspects of healthcare data access and thus is not unique to AI.

#### Allow AI for ML Training

```
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#MLTRAINING

```

Consent example: [Allow ML Training](Consent-AllowMLtraining.md)

#### Deny AI for ML Training

```
* provision.type = #deny
* provision.purpose[+] = $purposeOfUse#MLTRAINING

```

Consent example: [Deny ML Training](Consent-DenyMLtraining.md)

#### Allow AI for Clinical Decision Support

```
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#TREATDS

```

Consent example: [Allow AI for Clinical Decision Support](Consent-AllowCDS.md)

#### Deny AI for Clinical Decision Support

```
* provision.type = #deny
* provision.purpose[+] = $purposeOfUse#TREATDS

```

Consent example: [Deny AI for Clinical Decision Support](Consent-DenyCDS.md)

### Specific AI Systems or Models

For this we look to current identification of [AI as a FHIR Device resource](https://build.fhir.org/ig/HL7/aitransparency-ig/StructureDefinition-AI-Device.html). This Device would be indicated in a Consent when a specific AI system or model is identified in a `Consent.provision.actor.reference` with a `permit` or `deny` provision.

This model requires that all access by an AI are attributed to the FHIR Device describing the AI. This might not be the case given how the AI is orchestrated. This model also is fragile as a new model or software would be a new Device, and thus would require a new provision in the Consent to indicate consent or dissent for that new AI.

#### Allow a specific AI for a specific purpose

In this case there is simply a provision indicating that the AI is permitted for a given purpose. There are no restrictions on the kinds of actions or the kinds of data, but those could be added as additional restrictions.

```
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#TREATDS
* provision.actor[0].reference = Reference(AIdevice)
* provision.actor[0].role.text = "CDS"

```

Consent example: [Allow specific AI for specific purpose](Consent-AllowSpecificAIforSpecificPurpose.md)

### Limitations on AI Access

In the FHIR Consent/Permission there is a concept of a "limit" which is limits placed on a `permit` provision/rule. Where the limit might be an obligation or refrain, might be a specific additional data tag, or might be explicit removal of data elements. A "limit" should never be allowed to expose data where that limit can't be enforced. Specifically meaning that the recipient of the data must be trusted to enforce the obligation or refrain indicated. [Extension Registry Consent Provision Limit](https://build.fhir.org/ig/HL7/fhir-extensions/StructureDefinition-consent-provision-limit.html)

#### Allow AI for ML Training on De-Identified Data

```
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#MLTRAINING
* provision.modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#DEID 

```

Consent example: [Allow ML Training on De-Identified Data](Consent-AllowMLtrainingOnDeIdentifiedData.md)

### Combining AI provisions with normal clinical use

FHIR R4 Consent has only ONE root level `provision`. That root establishes the overall direction, and each nested `provision` is an exception to the rule immediately above it, alternating between `permit` and `deny` at each level. To express several independent AI rules alongside the usual Treatment, Payment, and Operations rules, the nesting therefore has to be deeper than the rules themselves suggest.

```
permit all of the addressed purposes
  deny ML training for sensitive data
    permit ML training for de-identified Normal data
  deny -- only so a refined permit can be expressed
    permit TPO for Normal confidentiality
    permit TPO for the care team including sensitive data

```

Note that R4 Consent does not define what applies when none of the provisions match; FHIR R6 adds a default rule at the top level.

Consent example: [Consent with all kinds of Provisions](Consent-AllAiProvisions.md)

### Conclusion

The above examples are showing simply how a Consent.provision iteration can carry permit and deny to indicate consent or dissent for AI. The examples are not exhaustive, and there are many other combinations of provisions that could be used to indicate consent or dissent for AI. The examples are also not indicating any specific data elements that are being allowed or denied, but those could be added as additional restrictions on the provision.

The reader should be able to take a quilted Consent that has various provisions indicating consent or dissent for various clinical use (TPO), and add in provisions indicating consent or dissent for various AI use-cases, and thus have a single Consent that indicates the patient's preferences for both traditional clinical use and AI use.

### Source

The source code for this Implementation Guide can be found on [GitHub](https://github.com/JohnMoehrke/ConsentAboutAI). See also the [Downloads and Analysis](download.md) page.



## Resource Content

```json
{
  "resourceType" : "ImplementationGuide",
  "id" : "johnmoehrke.ConsentAboutAI.example",
  "url" : "http://johnmoehrke.github.io/ConsentAboutAI/ImplementationGuide/johnmoehrke.ConsentAboutAI.example",
  "version" : "0.2.0",
  "name" : "JohnMoehrkeConsentAboutAI",
  "title" : "John Moehrke Consent About AI",
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
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001"
    }]
  }],
  "packageId" : "johnmoehrke.ConsentAboutAI.example",
  "license" : "CC-BY-SA-4.0",
  "fhirVersion" : ["4.0.1"],
  "dependsOn" : [{
    "id" : "hl7tx",
    "extension" : [{
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/implementationguide-dependency-comment",
      "valueMarkdown" : "Automatically added as a dependency - all IGs depend on HL7 Terminology"
    }],
    "uri" : "http://terminology.hl7.org/ImplementationGuide/hl7.terminology",
    "packageId" : "hl7.terminology.r4",
    "version" : "7.3.0"
  },
  {
    "id" : "extensions",
    "uri" : "http://hl7.org/fhir/extensions/ImplementationGuide/hl7.fhir.uv.extensions",
    "packageId" : "hl7.fhir.uv.extensions.r4",
    "version" : "current"
  }],
  "definition" : {
    "extension" : [{
      "extension" : [{
        "url" : "code",
        "valueString" : "copyrightyear"
      },
      {
        "url" : "value",
        "valueString" : "2021+"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "releaselabel"
      },
      {
        "url" : "value",
        "valueString" : "ci-build"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "show-inherited-invariants"
      },
      {
        "url" : "value",
        "valueString" : "false"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "usage-stats-opt-out"
      },
      {
        "url" : "value",
        "valueString" : "false"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "logging"
      },
      {
        "url" : "value",
        "valueString" : "progress"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "shownav"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "active-tables"
      },
      {
        "url" : "value",
        "valueString" : "false"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-contact"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-jurisdiction"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-publisher"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-version"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-binary"
      },
      {
        "url" : "value",
        "valueString" : "input/images"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "auto-oid-root"
      },
      {
        "url" : "value",
        "valueString" : "1.3.6.1.4.1.66281.2.1"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "autoload-resources"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-liquid"
      },
      {
        "url" : "value",
        "valueString" : "template/liquid"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-liquid"
      },
      {
        "url" : "value",
        "valueString" : "input/liquid"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-qa"
      },
      {
        "url" : "value",
        "valueString" : "temp/qa"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-temp"
      },
      {
        "url" : "value",
        "valueString" : "temp/pages"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-output"
      },
      {
        "url" : "value",
        "valueString" : "output"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-suppressed-warnings"
      },
      {
        "url" : "value",
        "valueString" : "input/ignoreWarnings.txt"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "path-history"
      },
      {
        "url" : "value",
        "valueString" : "http://johnmoehrke.github.io/ConsentAboutAI/history.html"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "template-html"
      },
      {
        "url" : "value",
        "valueString" : "template-page.html"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "template-md"
      },
      {
        "url" : "value",
        "valueString" : "template-page-md.html"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-context"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-copyright"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-license"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "apply-wg"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "fmm-definition"
      },
      {
        "url" : "value",
        "valueString" : "http://hl7.org/fhir/versions.html#maturity"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "propagate-status"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "excludelogbinaryformat"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueString" : "tabbed-snapshots"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-internal-dependency",
      "valueCode" : "hl7.fhir.uv.tools.r4#1.1.2"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "copyrightyear"
      },
      {
        "url" : "value",
        "valueString" : "2021+"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "releaselabel"
      },
      {
        "url" : "value",
        "valueString" : "ci-build"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "show-inherited-invariants"
      },
      {
        "url" : "value",
        "valueString" : "false"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "usage-stats-opt-out"
      },
      {
        "url" : "value",
        "valueString" : "false"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "logging"
      },
      {
        "url" : "value",
        "valueString" : "progress"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "shownav"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "active-tables"
      },
      {
        "url" : "value",
        "valueString" : "false"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-contact"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-jurisdiction"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-publisher"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-version"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-binary"
      },
      {
        "url" : "value",
        "valueString" : "input/images"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "auto-oid-root"
      },
      {
        "url" : "value",
        "valueString" : "1.3.6.1.4.1.66281.2.1"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "autoload-resources"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-liquid"
      },
      {
        "url" : "value",
        "valueString" : "template/liquid"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-liquid"
      },
      {
        "url" : "value",
        "valueString" : "input/liquid"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-qa"
      },
      {
        "url" : "value",
        "valueString" : "temp/qa"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-temp"
      },
      {
        "url" : "value",
        "valueString" : "temp/pages"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-output"
      },
      {
        "url" : "value",
        "valueString" : "output"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-suppressed-warnings"
      },
      {
        "url" : "value",
        "valueString" : "input/ignoreWarnings.txt"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "path-history"
      },
      {
        "url" : "value",
        "valueString" : "http://johnmoehrke.github.io/ConsentAboutAI/history.html"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "template-html"
      },
      {
        "url" : "value",
        "valueString" : "template-page.html"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "template-md"
      },
      {
        "url" : "value",
        "valueString" : "template-page-md.html"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-context"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-copyright"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-license"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "apply-wg"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "fmm-definition"
      },
      {
        "url" : "value",
        "valueString" : "http://hl7.org/fhir/versions.html#maturity"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "propagate-status"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "excludelogbinaryformat"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    },
    {
      "extension" : [{
        "url" : "code",
        "valueCode" : "tabbed-snapshots"
      },
      {
        "url" : "value",
        "valueString" : "true"
      }],
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-parameter"
    }],
    "resource" : [{
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Device"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Device-AIdevice.html"
      }],
      "reference" : {
        "reference" : "Device/AIdevice"
      },
      "name" : "AI Device",
      "description" : "A Device that indicates an AI system or model. This is not using the AI-Transparency profile in order to keep this IG simple.",
      "exampleBoolean" : true
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Consent"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Consent-AllowCDS.html"
      }],
      "reference" : {
        "reference" : "Consent/AllowCDS"
      },
      "name" : "Consent for Clinical Decision Support",
      "description" : "Consent for using data for clinical decision support purposes.",
      "exampleBoolean" : true
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Consent"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Consent-AllowMLtraining.html"
      }],
      "reference" : {
        "reference" : "Consent/AllowMLtraining"
      },
      "name" : "Consent for Machine Learning Training",
      "description" : "Consent for using data for machine learning training purposes.",
      "exampleBoolean" : true
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Consent"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Consent-AllowMLtrainingOnDeIdentifiedData.html"
      }],
      "reference" : {
        "reference" : "Consent/AllowMLtrainingOnDeIdentifiedData"
      },
      "name" : "Consent for Machine Learning Training on De-Identified Data",
      "description" : "Consent for using de-identified data for machine learning training purposes.",
      "exampleCanonical" : "http://johnmoehrke.github.io/ConsentAboutAI/StructureDefinition/ConsentWithLimits"
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Consent"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Consent-AllowSpecificAIforSpecificPurpose.html"
      }],
      "reference" : {
        "reference" : "Consent/AllowSpecificAIforSpecificPurpose"
      },
      "name" : "Consent to allow specific AI for a specific purpose",
      "description" : "Consent to allow the use of a specific AI device for a specific purpose.\r\nIn this case a Device is used to represent the specific AI system or model. In this case the purpose is for CDS use.",
      "exampleBoolean" : true
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Consent"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Consent-DenyCDS.html"
      }],
      "reference" : {
        "reference" : "Consent/DenyCDS"
      },
      "name" : "Consent to disallow Clinical Decision Support",
      "description" : "Consent to disallow using data for clinical decision support purposes.",
      "exampleBoolean" : true
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Consent"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Consent-DenyMLtraining.html"
      }],
      "reference" : {
        "reference" : "Consent/DenyMLtraining"
      },
      "name" : "Consent to disallow Machine Learning Training",
      "description" : "Consent to disallow using data for machine learning training purposes.",
      "exampleBoolean" : true
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Consent"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Consent-AllAiProvisions.html"
      }],
      "reference" : {
        "reference" : "Consent/AllAiProvisions"
      },
      "name" : "Consent with all kinds of Provisions",
      "description" : "Consent that includes provisions using the various AI mechanisms along with normal TPO.\r\n\r\nThis consent \r\n1. permits the patient's care team to have full access\r\n2. permits TPO purposes to have access to Normal data, but not sensitive data\r\n3. permits ML training purposes to have access to Normal de-identified data, but not sensitive data\r\n\r\nGiven that FHIR R4 Consent has only ONE root level provision, we need to extra deep nesting:\r\n\r\nProvisions\r\n- Permit all the purposes\r\n  - deny ML training for sensitive data\r\n    - permit ML training for de-identified data\r\n  - deny TPO -- just so we can skip to a permit\r\n    - permit TPO for normal confidentiality\r\n    - permit TPO for the care team for sensitive data",
      "exampleCanonical" : "http://johnmoehrke.github.io/ConsentAboutAI/StructureDefinition/ConsentWithLimits"
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "StructureDefinition:resource"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "StructureDefinition-ConsentWithLimits.html"
      }],
      "reference" : {
        "reference" : "StructureDefinition/ConsentWithLimits"
      },
      "name" : "Consent with use of the Limits extension",
      "description" : "Consent profile that includes the use of the consent-provision-limit extension to express limits on the use of data for ML training.",
      "exampleBoolean" : false
    },
    {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/resource-information",
        "valueString" : "Patient"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/implementationguide-page",
        "valueUri" : "Patient-ex-patient.html"
      }],
      "reference" : {
        "reference" : "Patient/ex-patient"
      },
      "name" : "The Patient example",
      "description" : "The patient example is a patient named John Jacob Jingleheimer Schmidt, who has a variety of names and identifiers. This example is used to demonstrate the use of multiple names, identifiers, and other patient attributes in FHIR. This is the patient giving consent for the use of their data for AI/ML training, with specific limits on the use of that data.",
      "exampleBoolean" : true
    }],
    "page" : {
      "extension" : [{
        "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-page-name",
        "valueUrl" : "toc.html"
      }],
      "nameUrl" : "toc.html",
      "title" : "Table of Contents",
      "generation" : "html",
      "page" : [{
        "extension" : [{
          "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-page-name",
          "valueUrl" : "index.html"
        }],
        "nameUrl" : "index.html",
        "title" : "Home",
        "generation" : "markdown"
      },
      {
        "extension" : [{
          "url" : "http://hl7.org/fhir/tools/StructureDefinition/ig-page-name",
          "valueUrl" : "download.html"
        }],
        "nameUrl" : "download.html",
        "title" : "Downloads and Analysis",
        "generation" : "markdown"
      }]
    },
    "parameter" : [{
      "code" : "path-resource",
      "value" : "fsh-generated/resources"
    },
    {
      "code" : "path-resource",
      "value" : "input/examples"
    },
    {
      "code" : "path-resource",
      "value" : "input/capabilities"
    },
    {
      "code" : "path-resource",
      "value" : "input/extensions"
    },
    {
      "code" : "path-resource",
      "value" : "input/models"
    },
    {
      "code" : "path-resource",
      "value" : "input/operations"
    },
    {
      "code" : "path-resource",
      "value" : "input/profiles"
    },
    {
      "code" : "path-resource",
      "value" : "input/resources"
    },
    {
      "code" : "path-resource",
      "value" : "input/vocabulary"
    },
    {
      "code" : "path-resource",
      "value" : "input/testing"
    },
    {
      "code" : "path-resource",
      "value" : "input/history"
    },
    {
      "code" : "path-pages",
      "value" : "template/config"
    },
    {
      "code" : "path-pages",
      "value" : "input/images"
    },
    {
      "code" : "path-tx-cache",
      "value" : "input-cache/txcache"
    }]
  }
}

```
