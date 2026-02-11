Consent that includes provisions using the various AI mechanisms along with normal TPO.

This consent 
1. permits the patient's care team to have full access
2. permits TPO purposes to have access to Normal data, but not sensitive dta
3. permits ML training purposes to have access to Normal de-identified data, but not sensitive data

Given that FHIR R4 Consent has only ONE root level provision, we need to extra deep nesting:

Provisions
- Permit all the purposes
  - deny ML training for sensitive data
    - permit ML training for de-identified data
  - deny TPO -- just so we can skip to a permit
    - permit TPO for normal confidentiality
    - permit TPO for the care team for sensitive data