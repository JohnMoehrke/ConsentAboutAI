# Consent with all kinds of Provisions - John Moehrke Consent About AI v0.2.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Consent with all kinds of Provisions**

## Example Consent: Consent with all kinds of Provisions

Consent that includes provisions using the various AI mechanisms along with normal TPO.

This consent

1. permits the patient's care team to have full access
1. permits TPO purposes to have access to Normal data, but not sensitive data
1. permits ML training purposes to have access to Normal de-identified data, but not sensitive data

Given that FHIR R4 Consent has only ONE root level provision, we need to extra deep nesting:

Provisions

* Permit all the purposes 
* deny ML training for sensitive data 
* permit ML training for de-identified data
 
* deny TPO – just so we can skip to a permit 
* permit TPO for normal confidentiality
* permit TPO for the care team for sensitive data
 
 

Profile: [Consent with use of the Limits extension](StructureDefinition-ConsentWithLimits.md)

Security Label: [test health data (Details: ActReason code HTEST = 'test health data')](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html)

## Participants

* **Role**: Patient
  * **Details**: [John Schmidt Other, DoB: 1923-07-25 ( http://example.org/mrn#123456)](Patient-ex-patient.md)
* **Role**: Party
  * **Details**: [http://example.org/organizations/ex-organization](http://example.org/organizations/ex-organization)

This consent is made under the policy [http://example.org/consent-policies#ml-training-consent-policy](http://example.org/consent-policies#ml-training-consent-policy) .

* [Rule](https://hl7.org/fhir/R4/formats.html#table): permit
  * [Who](https://hl7.org/fhir/R4/formats.html#table): 
  * [What](https://hl7.org/fhir/R4/formats.html#table)![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC): 
* [Rule](https://hl7.org/fhir/R4/formats.html#table): permit
  * [Who](https://hl7.org/fhir/R4/formats.html#table): 
  * [What](https://hl7.org/fhir/R4/formats.html#table)![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC): * Purpose: [ActReason: TREAT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-TREAT) (treatment)
* Purpose: [ActReason: HPAYMT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-HPAYMT) (healthcare payment)
* Purpose: [ActReason: HOPERAT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-HOPERAT) (healthcare operations)
* Purpose: [ActReason: MLTRAINING](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-MLTRAINING) (machine learning training)

* [Rule](https://hl7.org/fhir/R4/formats.html#table): ![](icon-qi-hidden.png)deny
  * [Who](https://hl7.org/fhir/R4/formats.html#table): 
  * [What](https://hl7.org/fhir/R4/formats.html#table)![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC): * Labled as: [ActCode: ETH](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActCode.html#v3-ActCode-ETH) (substance abuse information sensitivity)
* Labled as: [ActCode: BH](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActCode.html#v3-ActCode-BH) (behavioral health information sensitivity)
* Labled as: [ActCode: PREGNANT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActCode.html#v3-ActCode-PREGNANT) (pregnancy information sensitivity)
* Purpose: [ActReason: MLTRAINING](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-MLTRAINING) (machine learning training)

* [Rule](https://hl7.org/fhir/R4/formats.html#table): permit
  * [Who](https://hl7.org/fhir/R4/formats.html#table): 
  * [What](https://hl7.org/fhir/R4/formats.html#table)![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC): * Labled as: [Confidentiality: N](http://terminology.hl7.org/7.3.0/CodeSystem-v3-Confidentiality.html#v3-Confidentiality-N) (Normal)
* Purpose: [ActReason: MLTRAINING](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-MLTRAINING) (machine learning training)

* [Rule](https://hl7.org/fhir/R4/formats.html#table): ![](icon-qi-hidden.png)deny
  * [Who](https://hl7.org/fhir/R4/formats.html#table): 
  * [What](https://hl7.org/fhir/R4/formats.html#table)![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC): 
* [Rule](https://hl7.org/fhir/R4/formats.html#table): permit
  * [Who](https://hl7.org/fhir/R4/formats.html#table): 
  * [What](https://hl7.org/fhir/R4/formats.html#table)![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC): * Labled as: [Confidentiality: N](http://terminology.hl7.org/7.3.0/CodeSystem-v3-Confidentiality.html#v3-Confidentiality-N) (Normal)
* Purpose: [ActReason: TREAT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-TREAT) (treatment)
* Purpose: [ActReason: HPAYMT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-HPAYMT) (healthcare payment)
* Purpose: [ActReason: HOPERAT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-HOPERAT) (healthcare operations)

* [Rule](https://hl7.org/fhir/R4/formats.html#table): permit
  * [Who](https://hl7.org/fhir/R4/formats.html#table): * care team information receiver: [http://example.org/CareTeam/ex-patient-careteam](http://example.org/CareTeam/ex-patient-careteam)

  * [What](https://hl7.org/fhir/R4/formats.html#table)![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC): * Labled as: [Confidentiality: R](http://terminology.hl7.org/7.3.0/CodeSystem-v3-Confidentiality.html#v3-Confidentiality-R) (restricted)
* Purpose: [ActReason: TREAT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-TREAT) (treatment)
* Purpose: [ActReason: HPAYMT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-HPAYMT) (healthcare payment)
* Purpose: [ActReason: HOPERAT](http://terminology.hl7.org/7.3.0/CodeSystem-v3-ActReason.html#v3-ActReason-HOPERAT) (healthcare operations)

* [Rule](https://hl7.org/fhir/R4/formats.html#table): ![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3goXBCwdPqAP0wAAAldJREFUOMuNk0tIlFEYhp9z/vE2jHkhxXA0zJCMitrUQlq4lnSltEqCFhFG2MJFhIvIFpkEWaTQqjaWZRkp0g26URZkTpbaaOJkDqk10szoODP//7XIMUe0elcfnPd9zsfLOYplGrpRwZaqTtw3K7PtGem7Q6FoidbGgqHVy/HRb669R+56zx7eRV1L31JGxYbBtjKK93cxeqfyQHbehkZbUkK20goELEuIzEd+dHS+qz/Y8PTSif0FnGkbiwcAjHaU1+QWOptFiyCLp/LnKptpqIuXHx6rbR26kJcBX3yLgBfnd7CxwJmflpP2wUg0HIAoUUpZBmKzELGWcN8nAr6Gpu7tLU/CkwAaoKTWRSQyt89Q8w6J+oVQkKnBoblH7V0PPvUOvDYXfopE/SJmALsxnVm6LbkotrUtNowMeIrVrBcBpaMmdS0j9df7abpSuy7HWehwJdt1lhVwi/J58U5beXGAF6c3UXLycw1wdFklArBn87xdh0ZsZtArghBdAA3+OEDVubG4UEzP6x1FOWneHh2VDAHBAt80IbdXDcesNoCvs3E5AFyNSU5nbrDPZpcUEQQTFZiEVx+51fxMhhyJEAgvlriadIJZZksRuwBYMOPBbO3hePVVqgEJhFeUuFLhIPkRP6BQLIBrmMenujm/3g4zc398awIe90Zb5A1vREALqneMcYgP/xVQWlG+Ncu5vgwwlaUNx+3799rfe96u9K0JSDXcOzOTJg4B6IgmXfsygc7/Bvg9g9E58/cDVmGIBOP/zT8Bz1zqWqpbXIsd0O9hajXfL6u4BaOS6SeWAAAAAElFTkSuQmCC) Documentation for this format



## Resource Content

```json
{
  "resourceType" : "Consent",
  "id" : "AllAiProvisions",
  "meta" : {
    "profile" : ["http://johnmoehrke.github.io/ConsentAboutAI/StructureDefinition/ConsentWithLimits"],
    "security" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
      "code" : "HTEST"
    }]
  },
  "status" : "active",
  "scope" : {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/consentscope",
      "code" : "patient-privacy"
    }]
  },
  "category" : [{
    "coding" : [{
      "system" : "http://loinc.org",
      "code" : "64292-6",
      "display" : "Release of information consent"
    }]
  },
  {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/v3-ActCode",
      "code" : "IDSCL"
    }]
  }],
  "patient" : {
    "reference" : "Patient/ex-patient"
  },
  "dateTime" : "2022-06-13",
  "performer" : [{
    "reference" : "http://example.org/organizations/ex-organization"
  }],
  "sourceReference" : {
    "reference" : "http://example.org/documentreferences/ex-documentreference"
  },
  "policy" : [{
    "uri" : "http://example.org/consent-policies#ml-training-consent-policy"
  }],
  "provision" : {
    "type" : "permit",
    "purpose" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
      "code" : "TREAT"
    },
    {
      "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
      "code" : "HPAYMT"
    },
    {
      "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
      "code" : "HOPERAT"
    },
    {
      "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
      "code" : "MLTRAINING"
    }],
    "provision" : [{
      "type" : "deny",
      "securityLabel" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ActCode",
        "code" : "ETH"
      },
      {
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ActCode",
        "code" : "BH"
      },
      {
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ActCode",
        "code" : "PREGNANT"
      }],
      "purpose" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
        "code" : "MLTRAINING"
      }],
      "provision" : [{
        "modifierExtension" : [{
          "extension" : [{
            "url" : "control",
            "valueCodeableConcept" : {
              "coding" : [{
                "system" : "http://terminology.hl7.org/CodeSystem/v3-ActCode",
                "code" : "DEID"
              }]
            }
          }],
          "url" : "http://hl7.org/fhir/StructureDefinition/consent-provision-limit"
        }],
        "type" : "permit",
        "securityLabel" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/v3-Confidentiality",
          "code" : "N",
          "display" : "Normal"
        }],
        "purpose" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
          "code" : "MLTRAINING"
        }]
      }]
    },
    {
      "type" : "deny",
      "provision" : [{
        "type" : "permit",
        "securityLabel" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/v3-Confidentiality",
          "code" : "N",
          "display" : "Normal"
        }],
        "purpose" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
          "code" : "TREAT"
        },
        {
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
          "code" : "HPAYMT"
        },
        {
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
          "code" : "HOPERAT"
        }]
      },
      {
        "type" : "permit",
        "actor" : [{
          "role" : {
            "coding" : [{
              "system" : "http://terminology.hl7.org/CodeSystem/v3-ParticipationFunction",
              "code" : "AUTM"
            }]
          },
          "reference" : {
            "reference" : "http://example.org/CareTeam/ex-patient-careteam"
          }
        }],
        "securityLabel" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/v3-Confidentiality",
          "code" : "R"
        }],
        "purpose" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
          "code" : "TREAT"
        },
        {
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
          "code" : "HPAYMT"
        },
        {
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActReason",
          "code" : "HOPERAT"
        }]
      }]
    }]
  }
}

```
