#!/bin/sh
set -e
TAS_HOME="TAS_Demo"
WPMC_HOME="Workload_Monitor_Connector"
WPMC_ARTIFACT="WPMConnector.jar"
WPM_HOME="wpm"
TASC_HOME="ControllerTas"
RG_HOME="RadargunTASDemo"
LATTICE_HOME="LatticeCloudTM"
JD=1

echo "Downloading the TAS demo package"
echo "Downloading the Radargun Framework for the demo"
git clone https://github.com/cloudtm/RadargunTASDemo.git ${RG_HOME}

echo "Downloading LatticeCloudTM"
git clone git://github.com/cloudtm/LatticeCloudTM.git ${LATTICE_HOME} 

echo "Downloading WPM"
git clone https://github.com/cloudtm/wpm ${WPM_HOME} 
echo "Compiling WPM"
cd ${WPM_HOME}
if [ -n ${JD} ]; then
   git reset --hard 872985accae6d421299517861d238431ae007c10
fi
ant
cd ..

echo "Copying custom scripts and configuration files for wpm"
cp -r custom/* ${WPM_HOME}

echo "Downloading TasController package"
git clone https://github.com/cloudtm/ControllerTas.git ${TASC_HOME}

echo "Downloading the WPMConnector package"
git clone https://github.com/cloudtm/Workload_Monitor_Connector ${WPMC_HOME}
echo "Compiling the WPMConnector package"
cd ${WPMC_HOME}
if [ -n ${JD} ]; then
   git reset --hard 864522c2de22edc129b3d2b379e6523f545e0897
fi
ant
cd ..

echo "Moving WPMConnector jar to Tas Controller's lib folder"
cp ${WPMC_HOME}/${WPMC_ARTIFACT} ${TASC_HOME}/lib/
echo "Compiling the Tas Controller"
cd ${TASC_HOME}
ant makejar
cd ..

echo "Package successfully built"
exit 0
