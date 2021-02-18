# Create maps and water quality figures
figure no. | code filename |
| --- | --- |
| 2 | Short-term_Water_Quality_Figure.R |
| 3 | Long-term_Water_Quality_Figure.R |
| 4 | Map_of_Welfare_Simulation.R |

# Summary of Final Model Runs

## Typical Trip

code reference | eststo name | description |
| --- | --- | --- |
| 1.1 | Stage1_1 | Base model, first stage |
| 1.1 | Stage2_1a | Base model, second stage |
| 1.1 | Stage2_1b | Base model, second stage + basin FE |
| 1.1alt | Stage1_1alt | Base model with original travel cost, first stage |
| 1.1alt | Stage2_1aalt | Base model with original travel cost, second stage |
| 1.1alt | Stage2_1balt | Base model with original travel cost, second stage + basin FE |
| 1.2 | Stage1_2 | Base model, day-trips only, first stage |
| 1.2 | Stage2_2a | Base model, day-trips only, second stage |
| 1.2 | Stage2_2b | Base model, day-trips only, second stage + basin FE |
| 1.3 | Stage1_3 | Base model, choice set <= 150 miles, first stage |
| 1.3 | Stage2_3a | Base model, choice set <= 150 miles, second stage |
| 1.3 | Stage2_3b | Base model, choice set <= 150 miles, second stage + basin FE |
| 1.4 | Stage1_4 | Base model, distance error <= 100 miles, first stage |
| 1.4 | Stage2_4a | Base model, distance error <= 100 miles, second stage |
| 1.4 | Stage2_4b | Base model, distance error <= 100 miles, second stage + basin FE |
| 1.5 | Stage1_5 | Base model, positive trips, first stage |
| 1.5 | Stage2_5a | Base model, positive trips, second stage |
| 1.5 | Stage2_5b | Base model, positive trips, second stage + basin FE |
| 1.6 | Stage1_6 | Base model, lakes only, first stage |
| 1.6 | Stage2_6a | Base model, lakes only, second stage |
| 1.6 | Stage2_6b | Base model, lakes only, second stage + basin FE |
| 1.7 | Stage1_7 | Base model, rivers only, first stage |
| 1.7 | Stage2_7a | Base model, rivers only, second stage |
| 1.7 | Stage2_7b | Base model, rivers only, second stage + basin FE |
| 1.8 | Stage1_8 | Base model, drop 2001 survey, first stage |
| 1.8 | Stage2_8a | Base model, drop 2001 survey, second stage |
| 1.8 | Stage2_8b | Base model, drop 2001 survey, second stage + basin FE |


## Most Often
code reference | eststo name | description |
| --- | --- | --- |
| 2.1 | Stage1_1 | Base model, first stage |
| 2.1 | Stage2_1a | Base model, second stage |
| 2.1 | Stage2_1b | Base model, second stage + basin FE |
| 2.1alt | Stage1_1alt | Base model, with original travel cost, first stage |
| 2.1alt | Stage2_1aalt | Base model, with original travel cost, second stage |
| 2.1alt | Stage2_1balt | Base model, with original travel cost, second stage + basin FE |
| 2.2 | Stage1_2 | Base model, choice set <= 150 miles, first stage |
| 2.2 | Stage2_2a | Base model, choice set <= 150 miles, second stage |
| 2.2 | Stage2_2b | Base model, choice set <= 150 miles, second stage + basin FE |
| 2.3 | Stage1_3 | Base model, positive trips, first stage |
| 2.3 | Stage2_3a | Base model, positive trips, second stage |
| 2.3 | Stage2_3b | Base model, positive trips, second stage + basin FE |
| 2.4 | Stage1_4 | Base model, lakes only, first stage |
| 2.4 | Stage2_4a | Base model, lakes only, second stage |
| 2.4 | Stage2_4b | Base model, lakes only, second stage + basin FE |
| 2.5 | Stage1_5 | Base model, rivers only, first stage |
| 2.5 | Stage2_5a | Base model, rivers only, second stage |
| 2.5 | Stage2_5b | Base model, rivers only, second stage + basin FE |
| 2.6 | Stage1_6 | Base model, drop 2001 survey, first stage |
| 2.6 | Stage2_6a | Base model, drop 2001 survey, second stage |
| 2.6 | Stage2_6b | Base model, drop 2001 survey, second stage + basin FE |


## Quadratic
code reference | eststo name | description |
| --- | --- | --- |
| 3.1 | Stage1_1 | Base model, typical trip, quadratic, first stage |
| 3.1 | Stage2_1a | Base model, typical trip, quadratic, second stage |
| 3.1 | Stage2_1b | Base model, typical trip, quadratic, second stage + basin FE |
| 3.2 | Stage1_2 | Base model, most-often, quadratic, first stage |
| 3.2 | Stage2_2a | Base model, most-often, quadratic, second stage |
| 3.2 | Stage2_2b | Base model, most-often, quadratic, second stage + basin FE |


# Summary of Welfare Runs
Note: all models for welfare are linear and use the typical trip survey question

Model Number | Description |
| --- | --- |
| 1 | No restriction
| 2 | Use original travel cost variable
| 3 | Day trips only
| 4 | Choice set restricted to 150 miles
| 5 | Distance error of less than 100 miles
| 6 | Positive trips only
| 7 | Lakes only
| 8 | Rivers only
| 9 | Drop 2001 survey