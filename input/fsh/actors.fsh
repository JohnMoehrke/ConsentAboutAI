// Actors for this IG. An Actor is an abstract technical system that has requirements imposed upon it.

Instance: AccessControl
InstanceOf: ActorDefinition
Title: "Access Control"
Description: "The abstract technical system given the responsibility to enforce the Consents recorded according to this guide."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/ActorDefinition/AccessControl"
* name = "AccessControl"
* title = "Access Control"
* status = #active
* experimental = false
* type = #system
* description = "The Access Control actor is the abstract technical system given the responsibility to enforce the Consents recorded according to this guide. It makes and enforces access control decisions using the Consent provisions, including the PurposeOfUse declared by the requesting system and any limits placed upon a permit."

Instance: DataRequester
InstanceOf: ActorDefinition
Title: "Data Requester"
Description: "The AI system that directly requests and accesses data."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/ActorDefinition/DataRequester"
* name = "DataRequester"
* title = "Data Requester"
* status = #active
* experimental = false
* type = #system
* description = "The Data Requester actor is the AI system that directly requests and accesses data. It declares the applicable PurposeOfUse code when accessing data, and its accesses are attributed to the AI-Device describing the AI."

Instance: AiAgent
InstanceOf: ActorDefinition
Title: "AI Agent"
Description: "The agent (gateway) that accesses data on behalf of an AI, feeding that data to the AI."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/ActorDefinition/AiAgent"
* name = "AiAgent"
* title = "AI Agent"
* status = #active
* experimental = false
* type = #system
* description = "The AI Agent actor is the agent (gateway) that accesses data on behalf of an AI, feeding that data to the AI. It declares the applicable PurposeOfUse code of the AI it is feeding when accessing data, and attributes those accesses to the AI-Device describing the AI."

Instance: AiConsentAuthor
InstanceOf: ActorDefinition
Title: "AI-Consent Author"
Description: "The technical system that records the patient's decisions about AI as Consent resources conforming to the Consent about AI profile."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/ActorDefinition/AiConsentAuthor"
* name = "AiConsentAuthor"
* title = "AI-Consent Author"
* status = #active
* experimental = false
* type = #system
* description = "The AI-Consent Author actor is the technical system that records the patient's decisions about AI as Consent resources conforming to the Consent about AI profile. It captures the applicable PurposeOfUse codes, any specific AI Device, and any limits, as provisions."

// CapabilityStatements for the Actors

Instance: AccessControlCapability
InstanceOf: CapabilityStatement
Title: "Access Control Actor CapabilityStatement"
Description: "CapabilityStatement for the Access Control actor, which reads and evaluates Consents conforming to the Consent about AI profile in order to enforce them."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/CapabilityStatement/AccessControlCapability"
* actorDefinition = Canonical(AccessControl)
* name = "AccessControlCapability"
* title = "Access Control Actor CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-11-16"
* description = "The Access Control actor reads and evaluates Consents conforming to the Consent about AI profile in order to enforce them. It enforces the provisions, including the PurposeOfUse declared by the Data Requester or AI Agent, any specific AI Device identified, and any limits placed upon a permit."
* kind = #requirements
* fhirVersion = #6.0.0-snapshot1
* format[+] = #json
* format[+] = #xml
* rest[+].mode = #client
* rest[=].documentation = "The Access Control actor retrieves the Consents applicable to the patient and the requesting system."
* rest[=].resource[+].type = #Consent
* rest[=].resource[=].supportedProfile = Canonical(AiConsent)
* rest[=].resource[=].interaction[+].code = #read
* rest[=].resource[=].interaction[+].code = #search-type

Instance: AiConsentAuthorCapability
InstanceOf: CapabilityStatement
Title: "AI-Consent Author Actor CapabilityStatement"
Description: "CapabilityStatement for the AI-Consent Author actor, which records the patient's decisions about AI as Consents conforming to the Consent about AI profile."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/CapabilityStatement/AiConsentAuthorCapability"
* actorDefinition = Canonical(AiConsentAuthor)
* name = "AiConsentAuthorCapability"
* title = "AI-Consent Author Actor CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-11-16"
* description = "The AI-Consent Author actor records the patient's decisions about AI as Consents conforming to the Consent about AI profile."
* kind = #requirements
* fhirVersion = #6.0.0-snapshot1
* format[+] = #json
* format[+] = #xml
* rest[+].mode = #client
* rest[=].documentation = "The AI-Consent Author actor creates and updates Consents conforming to the Consent about AI profile."
* rest[=].resource[+].type = #Consent
* rest[=].resource[=].supportedProfile = Canonical(AiConsent)
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[+].code = #update
* rest[=].resource[=].interaction[+].code = #read

Instance: DataRequesterCapability
InstanceOf: CapabilityStatement
Title: "Data Requester Actor CapabilityStatement"
Description: "CapabilityStatement for the Data Requester actor, the AI system that directly requests and accesses data."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/CapabilityStatement/DataRequesterCapability"
* actorDefinition = Canonical(DataRequester)
* name = "DataRequesterCapability"
* title = "Data Requester Actor CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-11-16"
* description = "The Data Requester actor is the AI system that directly requests and accesses data. The kinds of data accessed are not constrained by this guide. When accessing data, it declares the applicable PurposeOfUse code, and its accesses are attributed to the AI-Device describing the AI."
* kind = #requirements
* fhirVersion = #6.0.0-snapshot1
* format[+] = #json
* format[+] = #xml
* rest[+].mode = #client
* rest[=].documentation = "The Data Requester actor accesses data of any kind, declaring the applicable PurposeOfUse code with each access, with the access attributed to the AI-Device describing the AI."

Instance: AiAgentCapability
InstanceOf: CapabilityStatement
Title: "AI Agent Actor CapabilityStatement"
Description: "CapabilityStatement for the AI Agent actor, the agent (gateway) that accesses data on behalf of an AI, feeding that data to the AI."
Usage: #definition
* url = "http://johnmoehrke.github.io/ConsentAboutAI/CapabilityStatement/AiAgentCapability"
* actorDefinition = Canonical(AiAgent)
* name = "AiAgentCapability"
* title = "AI Agent Actor CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-11-16"
* description = "The AI Agent actor is the agent (gateway) that accesses data on behalf of an AI, feeding that data to the AI. The kinds of data accessed are not constrained by this guide. When accessing data, it declares the applicable PurposeOfUse code of the AI it is feeding, and attributes those accesses to the AI-Device describing the AI."
* kind = #requirements
* fhirVersion = #6.0.0-snapshot1
* format[+] = #json
* format[+] = #xml
* rest[+].mode = #client
* rest[=].documentation = "The AI Agent actor accesses data of any kind on behalf of an AI, declaring the applicable PurposeOfUse code with each access, with the access attributed to the AI-Device describing the AI being fed."
