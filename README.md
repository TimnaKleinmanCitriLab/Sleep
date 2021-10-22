# Tel Aviv Sleep Project

### Table of Contents
1. [Introduction](https://github.com/TimnaKleinman/Citri-Lab-Sleep#intro)
2. [Useful Functions](#useful-functions)


## Intro
After trying to work with the raw data (saved in `W:\shared\Timna\Noa Tel Aviv Project\From Noa`) I understood it will take too long. So, I moved to use the already zscored and cleaned data from the open-source files (that are presented with the paper).

**NOTE**: I worked only with the sleep data, Noa said there are some problems with the open-source SEA data.

## Useful Functions
The useful functions are the ones for plotting the data:
1. `plot_EEG_by_FP_quantiles` - Plots the different EEG waves by FP quantiles - similar to the plot in the paper only I added shaded error bars (as a sanity check)
2. `plot_FP_by_EEG_quantiles` - Plots the different FP by EEG quantiles (opposite of **plot_EEG_by_FP_quantiles**)
3. `plot_NREM_FP_signal_at_transition` - Plots the NREM FP signal - after NREM and after REM. Plots each of these by mouse, and overall mice mean.
4. `plot_wake_FP_signal_at_transition` - Plots the wake FP signal - after NREM and after REM. Plots each of these by mouse, and overall mice mean.


All other functions are helper functions.
