# Research Project - Machine Learning for Friction Hysteresis Loops

## Project Overview

The aim of this project is to develop ML algorithms using existing friction data in the from of hysteresis loops to predict the performance of the nonlinear dynamic systems and understanding the physics behind.

Input parameters:

- Loading conditions (normal load, displacement amplitude, area)
- Hysteresis loops (friction force and displacement time signals)
- Contact interface scan/image

Output parameters:

- Friction coefficient ($\mu$)
- Tangential contact stiffness (k<sub>t</sub>)
- Energy dissipated
- Other behaviours (steady state, chattering, microslip, asymmetricity, etc)

A Round-Robin test campaign was designed and performed at different friction rigs to collect a multitude of comparable hysteresis loops measured.


## Proposed Models

### Model 1

Input: hysteresis loops (force and displacement time signals)

Output: $\mu$, k<sub>t</sub>, and energy dissipated

Challenges:
- At **large k<sub>t</sub> value**, the slope is so steep that even a slight change would lead to large variations.
- The values are very noise sensitive.
- Use ML to solve the issue of inaccuracies at high k<sub>t</sub> value.

Possible ideas:
- If there exists a large variation on the evolution of k<sub>t</sub>, don’t include it in the training set. So only un-anomaly data will be fed to the algorithm.
- Detect anomalies (values with large variations) by comparing with the results from Model 2. 

***

### Model 2

Input: loading conditions (normal load, displacement amplitude and area)

Output: $\mu$, k<sub>t</sub>

Predict the parameters at the test conditions that are unable to be achieved with the current test rigs.

Challenges:
- Friction Coefficient ($\mu$) may only depend on the material properties.
- Different rigs sometimes have **different performance** so the user will need to provide their own training set from their rig.
- Inaccurate to predict the performance with loading conditions that are out of range of the existing dataset. (e.g., Imperial used displacement of 1, 14 & 24.5 mum so it may not well predict the behaviour at 40 mum.)

Possible ideas:
- Support Vector Regression
- Compare the predicted results with Model 1 and mutually improve each other.
- Fix the issue of inaccuracies caused by value variations shown in Model 1.

***

### Model 3

Input: loading conditions (normal load, displacement amplitude and area) + contact interface scan/image (worn area and distribution)

Output: $\mu$, k<sub>t</sub> (k<sub>t</sub> Left and Right)

This can be an extension of Model 2 since there are more input features to obtain a more accurate model.
Investigate on the influence of worn area on the behaviour.

***

### Model 4

Input: hysteresis loops evolution (force and displacement time signals) 

Output: $\mu$, k<sub>t</sub>, and energy dissipated, steady state, chattering

Time and cumulative energy dissipated to achieve steady state.

Chattering effect with wear.

Challenges:
- How to quantify chattering?

Possible ideas:
- The microslip regime and asymmetricity can also be predicted and these can be combined to plot the hysteresis loops evolution at new loading conditions.



