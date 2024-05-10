# Piezoelectricity_nanofibers
This repository is made for measuring piezoelectricity in PVDF nanofibers membranes. It allows connection with Tektronix oscilloscope through Matlab to measure the voltages generated, and to a strain gauge through Arduino to store the loads applied.

The code "oscilloscope_matlab" connects Matlab to the Tektronix oscilloscope and saves the data to your computer. You will need to have installed:
- Instrument Control Toolbox (Add-on Matlab).
- Instrument Control Toolbox Support Package for National Instruments VISA and ICP Interfaces (Add-on Matlab).
- NI VISA

The code "analysis_voltages" takes the data stored in the previous code and calculates the average of the peak-to-peak voltage and the mean load applied. It also generates a linear regression for all the data points taken and compare the performance of the 3 nanofibers membranes.

The "gauge" code measures the loads gotten from the strain gauge and prints them in the Arduino Serial prompt. 
