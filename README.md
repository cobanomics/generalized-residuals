# Generalized Residuals

GENERALIZED RESIDUALS IN STATA

The goal of this new project is to program a user-written Stata command, which is suitable for the version 11 and upwards. Based on the methodological work of GOURIEROUX ET AL. (1987), the new command calculates generalized residuals from nonlinear models, such as the probit regression, ordered probit regression, or tobit regression. 

Since there are different ways in Stata to run nonlinear regressions, such as probit regressions, we have to consider the choice of the user within the program. Most important, the GENRES command is intended to be a post-estimation command. Thus, the help-file of the new command has to inform the researcher that the command has to be directly integrated after the estimation within the applied do-file.




Literature:

Gourieroux, C., Monfort, A., Renault, E. and Trognon, A. (1987). Generalised residuals, Journal of Econometrics 34(1), pp.5 – 32.
