# Artifacts Summary - John Moehrke Consent About AI v0.1.0

* [**Table of Contents**](toc.md)
* **Artifacts Summary**

## Artifacts Summary

This page provides a list of the FHIR artifacts defined as part of this implementation guide.

### Structures: Resource Profiles 

These define constraints on FHIR resources for systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [Consent with use of the Limits extension](StructureDefinition-ConsentWithLimits.md) | Consent profile that includes the use of the consent-provision-limit extension to express limits on the use of data for ML training. |

### Example: Example Instances 

These are example instances that show what data produced and consumed by systems conforming with this implementation guide might look like.

| | |
| :--- | :--- |
| [AI Device](Device-AIdevice.md) | A Device that indicates an AI system or model. This is not using the AI-Transparency profile in order to keep this IG simple. |
| [Consent for Clinical Decision Support](Consent-AllowCDS.md) | Consent for using data for clinical decision support purposes. |
| [Consent for Machine Learning Training](Consent-AllowMLtraining.md) | Consent for using data for machine learning training purposes. |
| [Consent for Machine Learning Training on De-Identified Data](Consent-AllowMLtrainingOnDeIdentifiedData.md) | Consent for using de-identified data for machine learning training purposes. |
| [Consent to allow specific AI for a specific purpose](Consent-AllowSpecificAIforSpecificPurpose.md) | Consent to allow the use of a specific AI device for a specific purpose. In this case a Device is used to represent the specific AI system or model. In this case the purpose is for CDS use. |
| [Consent to disallow Clinical Decision Support](Consent-DenyCDS.md) | Consent to disallow using data for clinical decision support purposes. |
| [Consent to disallow Machine Learning Training](Consent-DenyMLtraining.md) | Consent to disallow using data for machine learning training purposes. |
| [Consent with all kinds of Provisions](Consent-AllAiProvisions.md) | Consent that includes provisions using the various AI mechanisms along with normal TPO. This consent 1. permits the patient's care team to have full access
1. permits TPO purposes to have access to Normal data, but not sensitive data
1. permits ML training purposes to have access to Normal de-identified data, but not sensitive data Given that FHIR R4 Consent has only ONE root level provision, we need to extra deep nesting: Provisions
* Permit all the purposes 
* deny ML training for sensitive data 
 

* permit ML training for de-identified data - deny TPO – just so we can skip to a permit 
* permit TPO for normal confidentiality 
* permit TPO for the care team for sensitive data

 |
| [The Patient example](Patient-ex-patient.md) | The patient example is a patient named John Jacob Jingleheimer Schmidt, who has a variety of names and identifiers. This example is used to demonstrate the use of multiple names, identifiers, and other patient attributes in FHIR. This is the patient giving consent for the use of their data for AI/ML training, with specific limits on the use of that data. |

