// This includes the AI specific Consent profiles and examples. 

Alias: $purposeOfUse = http://terminology.hl7.org/CodeSystem/v3-ActReason
Alias: $obligation = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $limit = http://hl7.org/fhir/StructureDefinition/consent-provision-limit
Alias: $obligationExt = http://hl7.org/fhir/StructureDefinition/obligation
Alias: $aiDeviceType = http://terminology.hl7.org/CodeSystem/AIdeviceTypeCS

ValueSet: AiPurposeOfUse
Id: ai-purposeofuse
Title: "AI Purposes Of Use"
Description: "The PurposeOfUse codes for AI uses of data: machine learning training, clinical decision support, and payment decision support."
* ^experimental = false
* $purposeOfUse#MLTRAINING
* $purposeOfUse#TREATDS
* $purposeOfUse#PMTDS

Invariant: aic-ai-device
Description: "When the provision purpose includes an AI purpose of use, an actor that is a Device must carry the Artificial-Intelligence device type coding. No purpose, or non-AI purposes, place no constraint on the actor. Note the AI-Transparency AI-Device profile is not available for R6, so the device type coding is enforced instead."
Severity: #error
Expression: "purpose.where(memberOf('http://johnmoehrke.github.io/ConsentAboutAI/ValueSet/ai-purposeofuse')).exists() implies actor.reference.resolve().ofType(Device).all(type.coding.where(system = 'http://terminology.hl7.org/CodeSystem/AIdeviceTypeCS' and code = 'Artificial-Intelligence').exists())"

Profile: AiConsent
Parent: Consent
Id: ai-consent
Title: "Consent about AI"
Description: """
A Consent profile for recording a patient's decision to permit or deny use of AI.

- The category indicates Release of Information consent and information disclosure.
- The subject and date are required.
- The controller is the Organization capturing and enforcing the consent.
- The signed consent paperwork, when referenced, is a DocumentReference.
- The decision carries the default (permit or deny), and each provision is an exception carrying the applicable PurposeOfUse code(s), such as MLTRAINING or TREATDS.
- When a specific AI system or model is permitted or denied, the provision.actor.reference identifies that AI as a Device carrying the Artificial-Intelligence device type.
- A provision may carry a consent-provision-limit modifierExtension, such as an obligation to de-identify.
"""
// Obligations tying this profile to the Actors: the AI-Consent Author populates conformant Consents; the Access Control processes (enforces) them.
* ^extension[$obligationExt][+].extension[code].valueCode = #SHALL:populate
* ^extension[$obligationExt][=].extension[actor].valueCanonical = Canonical(AiConsentAuthor)
* ^extension[$obligationExt][+].extension[code].valueCode = #SHALL:process
* ^extension[$obligationExt][=].extension[actor].valueCanonical = Canonical(AccessControl)
* subject 1..1 MS
* date 1..1 MS
* decision 1..1 MS
* decision ^short = "The default decision (permit or deny); each provision is an exception"
* provision MS
* provision obeys aic-ai-device
* provision.provision obeys aic-ai-device
// The limit may appear on any provision; defined at two levels of nesting, which the publisher recognizes as applying to infinite levels.
* provision.modifierExtension contains $limit named limit 0..1
* provision.modifierExtension[limit] ^short = "Limits, such as an obligation to de-identify, placed on a permit provision"
* provision.provision.modifierExtension contains $limit named limit 0..1
* provision.provision.modifierExtension[limit] ^short = "Limits, such as an obligation to de-identify, placed on a permit provision"
* provision ^slicing.discriminator.type = #value
* provision ^slicing.discriminator.path = "purpose"
* provision ^slicing.rules = #open
* provision contains aiProvision 0..*
* provision[aiProvision] ^short = "Provision addressing an AI purpose of use"
* provision[aiProvision].purpose 1..* MS
* provision[aiProvision].purpose from AiPurposeOfUse (required)
* provision[aiProvision].purpose ^short = "PurposeOfUse code(s) addressed, such as MLTRAINING or TREATDS"
* provision[aiProvision].purpose ^comment = "Any access by the AI, or by an agent feeding the AI, SHALL declare the applicable PurposeOfUse code when accessing data."
* provision[aiProvision].actor MS
* provision[aiProvision].actor ^comment = "When a specific AI system or model is permitted or denied, the actor.reference SHALL identify that AI as a Device, and all data access by the AI SHALL be attributed to that Device."
* provision[aiProvision].actor ^slicing.discriminator.type = #type
* provision[aiProvision].actor ^slicing.discriminator.path = "reference.resolve()"
* provision[aiProvision].actor ^slicing.rules = #open
* provision[aiProvision].actor contains aiDevice 0..*
* provision[aiProvision].actor[aiDevice] ^short = "The specific AI system or model being permitted or denied"
* provision[aiProvision].actor[aiDevice].reference only Reference(Device)
// The level 1 profiling is replicated at level 2; the publisher recognizes replicated profiling at two levels as applying to infinite levels.
* provision[aiProvision].provision ^slicing.discriminator.type = #value
* provision[aiProvision].provision ^slicing.discriminator.path = "purpose"
* provision[aiProvision].provision ^slicing.rules = #open
* provision[aiProvision].provision contains aiProvision 0..*
* provision[aiProvision].provision[aiProvision] ^short = "Provision addressing an AI purpose of use"
* provision[aiProvision].provision[aiProvision].purpose 1..* MS
* provision[aiProvision].provision[aiProvision].purpose from AiPurposeOfUse (required)
* provision[aiProvision].provision[aiProvision].actor ^slicing.discriminator.type = #type
* provision[aiProvision].provision[aiProvision].actor ^slicing.discriminator.path = "reference.resolve()"
* provision[aiProvision].provision[aiProvision].actor ^slicing.rules = #open
* provision[aiProvision].provision[aiProvision].actor contains aiDevice 0..*
* provision[aiProvision].provision[aiProvision].actor[aiDevice] ^short = "The specific AI system or model being permitted or denied"
* provision[aiProvision].provision[aiProvision].actor[aiDevice].reference only Reference(Device)

/* asked about nested context - https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/extension.20context.20on.20nested.20element/with/616962935 */


Instance: AllowMLtraining
InstanceOf: AiConsent
Title: "Consent for Machine Learning Training"
Description: "Consent for using data for machine learning training purposes. The default decision is deny, with a provision permitting ML training."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* decision = #deny
* provision.purpose[+] = $purposeOfUse#MLTRAINING



Instance: DenyMLtraining
InstanceOf: AiConsent
Title: "Consent to disallow Machine Learning Training"
Description: "Consent to disallow using data for machine learning training purposes. The default decision is permit, with a provision denying ML training."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* decision = #permit
* provision.purpose[+] = $purposeOfUse#MLTRAINING


Instance: AllowMLtrainingOnDeIdentifiedData
InstanceOf: AiConsent
Title: "Consent for Machine Learning Training on De-Identified Data"
Description: "Consent for using de-identified data for machine learning training purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* decision = #deny
* provision.purpose[+] = $purposeOfUse#MLTRAINING
* provision.modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#DEID 


Instance: ex-consent-with-limits
InstanceOf: AiConsent
Title: "non AI example of Consent with Limits"
Description: "Consent using all the parts of the limits extension for example sake."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* decision = #deny
* provision.purpose[+] = $purposeOfUse#MLTRAINING
* provision.modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#DEID 
* provision.modifierExtension[limit].extension[tag].valueCodeableConcept = http://terminology.hl7.org/CodeSystem/v3-ActCode#HIV
* provision.modifierExtension[limit].extension[element].valueId = "elementId1"
* provision.modifierExtension[limit].extension[path].valueString = "Observation.subject"


Instance: AllowCDS
InstanceOf: AiConsent
Title: "Consent for Clinical Decision Support"
Description: "Consent for using data for clinical decision support purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#cds-consent-policy"
* decision = #deny
* provision.purpose[+] = $purposeOfUse#TREATDS

Instance: DenyCDS
InstanceOf: AiConsent
Title: "Consent to disallow Clinical Decision Support"
Description: "Consent to disallow using data for clinical decision support purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#cds-consent-policy"
* decision = #permit
* provision.purpose[+] = $purposeOfUse#TREATDS


Instance: AllowPaymentDS
InstanceOf: AiConsent
Title: "Consent for Payment Decision Support"
Description: "Consent for using data for payment decision support purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#payment-ds-consent-policy"
* decision = #deny
* provision.purpose[+] = $purposeOfUse#PMTDS


Instance: DenyPaymentDS
InstanceOf: AiConsent
Title: "Consent to disallow Payment Decision Support"
Description: "Consent to disallow using data for payment decision support purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#payment-ds-consent-policy"
* decision = #permit
* provision.purpose[+] = $purposeOfUse#PMTDS


Instance: AIdevice
InstanceOf: Device
Title: "AI Device"
Description: """
A Device that indicates an AI system or model. The AI-Transparency AI-Device profile is not available for R6, so this Device carries the Artificial-Intelligence device type coding that profile requires.
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type = $aiDeviceType#Artificial-Intelligence
* type.coding[+] = http://snomed.info/sct#736253002 
* type.text = "Artificial intelligence device"
* deviceVersion.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"

Instance: AllowSpecificAIforSpecificPurpose
InstanceOf: AiConsent
Title: "Consent to allow specific AI for a specific purpose"
Description: "Consent to allow the use of a specific AI device for a specific purpose.
In this case a Device is used to represent the specific AI system or model. In this case the purpose is for CDS use."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#specific-ai-consent"
* decision = #deny
* provision.purpose[+] = $purposeOfUse#TREATDS
* provision.actor[0].reference = Reference(AIdevice)
* provision.actor[0].role.text = "CDS"

Instance: DenySpecificAIforSpecificPurpose
InstanceOf: AiConsent
Title: "Consent to deny specific AI for a specific purpose"
Description: "Consent to deny the use of a specific AI device for a specific purpose.
In this case a Device is used to represent the specific AI system or model. In this case the purpose is for CDS use."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#specific-ai-consent"
* decision = #permit
* provision.purpose[+] = $purposeOfUse#TREATDS
* provision.actor[0].reference = Reference(AIdevice)
* provision.actor[0].role.text = "CDS"

Instance: AllAiProvisions
InstanceOf: AiConsent
Title: "Consent with all kinds of Provisions"
Description: "Consent that includes provisions using the various AI mechanisms along with normal TPO.

This consent 
1. permits the patient's care team to have full access
2. permits TPO purposes to have access to Normal data, but not sensitive data
3. permits ML training purposes to have access to Normal de-identified data, but not sensitive data

Given that FHIR R6 Consent has many root level provision, we can be rather flat:

Provisions
- deny by default
- permit ML training for de-identified data
  - deny ML training for sensitive data
- permit TPO for normal confidentiality
- permit TPO for the care team for sensitive data
"
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* decision = #deny

* provision[+]
  // permit ML to see Normal data that is de-identified
  * purpose[+] = $purposeOfUse#MLTRAINING
  * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
  * modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#DEID 
  * provision[0]
    // deny ML training to see sensitive topics
    * purpose[+] = $purposeOfUse#MLTRAINING
    * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#ETH
    * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#BH
    * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#PREGNANT
    // Note this does leave ambiguous any R data that are not these three sensitivity tags.

* provision[+]
  // permit TPO with normal confidentiality and the relevant purposes of use
  * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
  * purpose[+] = $purposeOfUse#TREAT
  * purpose[+] = $purposeOfUse#HPAYMT
  * purpose[+] = $purposeOfUse#HOPERAT
* provision[+]
  // permit TPO for the careTeam of this patient for sensitive topics
  * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#R
  * purpose[+] = $purposeOfUse#TREAT
  * purpose[+] = $purposeOfUse#HPAYMT
  * purpose[+] = $purposeOfUse#HOPERAT    
  * actor.role = http://terminology.hl7.org/CodeSystem/v3-ParticipationFunction#AUTM  
  * actor.reference.reference = "http://example.org/CareTeam/ex-patient-careteam"


Instance: ThreeLevelsDeep
InstanceOf: AiConsent
Title: "Consent with provisions three levels deep"
Description: "Consent that nests provisions three levels deep to assure that the AiConsent profiling applies at the third level.

Provisions
- decision: deny by default
- permit TPO and AI clinical decision support purposes (level 1)
  - deny AI clinical decision support (level 2)
    - permit a specific AI Device for clinical decision support on Normal data, with a limit prohibiting reuse (level 3)
"
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* subject = Reference(Patient/ex-patient)
* date = "2022-06-13"
* controller.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policyBasis.uri = "http://example.org/consent-policies#three-levels-deep"
* decision = #deny

* provision[0]
  // permit all of the purposeOfUse that are addressed positively in this Consent (level 1)
  * purpose[+] = $purposeOfUse#TREAT
  * purpose[+] = $purposeOfUse#HPAYMT
  * purpose[+] = $purposeOfUse#HOPERAT
  * purpose[+] = $purposeOfUse#TREATDS

  * provision[0]
    // deny AI clinical decision support generally (level 2)
    * purpose[+] = $purposeOfUse#TREATDS

    * provision[0]
      // permit a specific AI Device for clinical decision support on Normal data, prohibiting reuse (level 3)
      * purpose[+] = $purposeOfUse#TREATDS
      * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
      * actor[0].reference = Reference(AIdevice)
      * actor[0].role.text = "CDS"
      * modifierExtension[$limit].extension[control].valueCodeableConcept = $obligation#NOREUSE
