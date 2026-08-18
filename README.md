
# Consent About AI use

An experimental FHIR implementation guide showing how a `Consent` can permit or deny the use of Artificial Intelligence for a given patient.

## Scope

Patients increasingly have opinions about how AI touches their health information. They may agree to AI-assisted clinical decision support, object to their data being used to train models, or agree to training only on de-identified data. This guide explores how those preferences can be recorded in a FHIR R4 `Consent` so that an access-control engine can evaluate them, rather than leaving them as free text that no system can enforce.

## Solution

The IG demonstrates two complementary patterns, plus a way to attach conditions to a permit:

- **By purpose of use** - `Consent.provision.purpose` carries codes such as `MLTRAINING` for model training or `TREATDS` for clinical decision support. This keeps the consent independent of any particular AI product, and relies on the AI, or the agent feeding it, accurately declaring its purpose of use.
- **By specific AI** - `Consent.provision.actor.reference` points at the `Device` that represents a specific AI system or model. This is precise but fragile, since a new model or version is a new `Device`.
- **Limits on a permit** - the standard `consent-provision-limit` extension brings the FHIR R6 `Permission.rule.limit` concept to `Consent.provision`, so a permit can require an obligation such as de-identification, add a security tag, or require specific elements to be removed. A limit must never expose data where that limit cannot be enforced.

Because FHIR R4 `Consent` has a single root `provision`, nested provisions alternate between `permit` and `deny`, each being an exception to the rule above it. The IG includes an example that combines AI provisions with ordinary Treatment, Payment, and Operations rules in one Consent.

- Formal publication: [johnmoehrke.github.io/ConsentAboutAI](https://johnmoehrke.github.io/ConsentAboutAI)
- CI build: [build.fhir.org/ig/JohnMoehrke/ConsentAboutAI](http://build.fhir.org/ig/JohnMoehrke/ConsentAboutAI/branches/main/index.html)
- CI build for FHIR R6: [build.fhir.org/ig/JohnMoehrke/ConsentAboutAI branch R6](https://build.fhir.org/ig/JohnMoehrke/ConsentAboutAI/branches/R6/index.html)
- GitHub source: [github.com/JohnMoehrke/ConsentAboutAI](https://github.com/JohnMoehrke/ConsentAboutAI)

## Related Consent Implementation Guides

- [Emancipation using Consent](https://github.com/JohnMoehrke/emancipation)
- [Related Person Consent](https://github.com/JohnMoehrke/RelatedPersonConsent)
- [Consent with Segmentation](https://github.com/JohnMoehrke/ConsentWithSegmentation)
- [Consent with XACML encoded rules](https://github.com/JohnMoehrke/xacml-consent)

## Status

This is a trial IG to explore using FHIR Consent resources. The content is from the perspective of the author and is not endorsed by HL7 or any other organization. It is intended to start a discussion and to solicit feedback.

## Blog Article

### Asking the Patient About AI, and Recording the Answer So It Can Be Enforced

Patients are being asked, more and more often, how they feel about Artificial Intelligence touching their health information. Some are comfortable with an AI helping their clinician reach a diagnosis. Some object to their records being used to train a model that will be sold to someone else. Many sit in between, and would agree to training if the data were first de-identified.

Capturing that answer on a consent form is easy. Capturing it so that a system can actually act on it is the hard part. A sentence in a scanned PDF cannot stop a data extract from feeding a training pipeline. This is where the FHIR `Consent` resource earns its keep: it is the place to record the organization's actionable interpretation of what the patient decided, while the signed paperwork remains the legal record and is referenced from the Consent.

There are two reasonable ways to say "AI" inside a Consent.

The first is by **purpose of use**. HL7 terminology already defines codes for why data is being accessed, including `MLTRAINING` for model training and `TREATDS` for decision support. A provision that permits or denies one of those purposes stays true even when the vendor changes their model next quarter. The cost is a trust assumption: whatever pulls the data must honestly declare its purpose. That is not a new assumption in healthcare, and it is the same one we already rely on for treatment, payment, and operations.

The second is by **specific AI**, using a `Device` resource to identify the model or system, referenced from `Consent.provision.actor`. This is more precise, and it is attractive when a patient agrees to one named tool and nothing else. It is also brittle. A new version is a new Device, every access has to be attributed to that Device, and the consent needs maintenance as the technology moves.

Neither pattern alone covers the most interesting answer, which is "yes, but". Yes, you may train on my data, but only de-identified. FHIR R6 handles this with `Permission.rule.limit`, and the same concept is available to R4 through the standard `consent-provision-limit` extension, so a permit can carry an obligation such as de-identification, a required security tag, or a list of elements that must be removed. The important rule of thumb is that a limit must never be used to release data where nobody can enforce the limit.

There is one modeling wrinkle worth calling out. FHIR R4 `Consent` has exactly one root provision. Everything below it is an exception to the rule immediately above, alternating between permit and deny. So expressing several parallel rules, say AI training rules sitting next to ordinary treatment and payment rules, requires nesting that is deeper than the rules themselves feel like they should be. The guide includes a worked example of exactly that, mixing AI provisions with normal clinical use in a single Consent.

The larger point is that consent about AI does not need a new resource or a new specification. It needs the existing Consent provisions to be filled in with codes an engine can evaluate, and it needs the conditions on a permit to be explicit rather than implied.

This guide is experimental and meant to provoke discussion. For the profile and the examples, see:

- [GitHub source repository](https://github.com/JohnMoehrke/ConsentAboutAI)
- [CI build](http://build.fhir.org/ig/JohnMoehrke/ConsentAboutAI/branches/main/index.html)
- [Formal publication](https://johnmoehrke.github.io/ConsentAboutAI)

The formal publication is the stable reference for this work; the CI build shows the current development state.
