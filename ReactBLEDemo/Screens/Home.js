import React from 'react';
import { View, ListView, StyleSheet, Text ,TouchableHighlight,Button,titleStyle,Alert} from 'react-native';
import CustomListView from './../App/CustomListView';
import { StackNavigator } from 'react-navigation';
import {NativeModules,NativeEventEmitter} from 'react-native';
import DeviceListView from './../App/DeviceListView'
import styles from './HomeStyle'
import NumberCounter from './../App/NumberCounter'

let bridgeReact = NativeModules.BirdgeReact;

const { BridgeReactEmitter } = NativeModules;

const scanningEmitter = new NativeEventEmitter(BridgeReactEmitter);

const subscription = undefined;

const scanDeviceCallback       = "scanDeviceFound"   ;
const scanRSSIUpdateCallback   = "scanRSSIUpdate"    ;
const readCharCompleteCallback = "readCharsComplete" ;

class Home extends React.Component<Props> {

    constructor(){
      super();
      this.state = {
          textValue:'Change me',
          scannedResultArray : [{}],
          scannedResult1:[],
          isToggled: false,
      }
    }

    static navigationOptions = ({navigation}) => ({
      title: "Scanner",
      headerTitleStyle:{
        fontSize:24,
        alignSelf:'center'
      },
    });

    // On Click Start Scan
    startScan() {
      console.log('START SCAN');
        // this.setState({isToggled:true})
        this.props.startScan();
        // this.props.addScanResult({deviceName:"Device"});
      this.createSubcriptionForUpdates()
    }

    createSubcriptionForUpdates() {
      console.log("Triggered --------- createSubcriptionForUpdates");
      subscription = scanningEmitter.addListener(
        'ScannedResult',
        (scanResultObj) => { // On Callback update data source
          if(scanResultObj.errorMessage) 
          {
            this.stopScan();
            Alert.alert(scanResultObj.errorMessage);
            
          }else {
            this.performOpearationBasedOnCallbackType(scanResultObj);
          }
        }
        );
        bridgeReact.scanForDevices(); // Call native scan 
    }

    // Perform Operation Based on Callback Type
    performOpearationBasedOnCallbackType (scanResultObj) {
      let callbackType = scanResultObj.callBackOn;
      console.log('\n Callback :',callbackType);
      if(scanDeviceCallback == callbackType) 
      {
            if(this.props.scannedResultArray.length >= 1000) // Add only 1000 records
            {
              this.removeSubscription() // Remove listener
              console.log("Subscription Removed!");
            }else {
              this.props.addScanResult(scanResultObj);
            }
      }
      else if (scanRSSIUpdateCallback == callbackType) 
      {
          this.props.updateScanResult(scanResultObj);
      }
      else if (readCharCompleteCallback == callbackType) 
      {
        console.log('Device : '+scanResultObj)
        this.removeSubscription()
        const device = this.props.scannedResultArray.map(item => {
          if (item.deviceUUID === scanResultObj.deviceUUID){
            return item
          }
        })
        this.props.addDevice(
          {...device,
          hardwareVersion:scanResultObj.hardwareVersion,
          softwareVersion:scanResultObj.softwareVersion,
          firmwareVersion:scanResultObj.firmwareVersion,
          sensorLocation:scanResultObj.sensorLocation,
          heartRate:scanResultObj.heartRate,
          callBackOn:scanResultObj.callBackOn,
          deviceUUID:scanResultObj.deviceUUID
        });
      }
      console.log('Device List : '+this.props.deviceList)
    }

    removeSubscription () {
      if(subscription) {
        subscription.remove();
        subscription = null;
      }
    }

    // On clicking stop scan
    stopScan(){
        console.log('STOP SCAN');
        bridgeReact.stopScan();
        // this.setState({isToggled:false})
        this.props.stopScan();
        this.removeSubscription()
    }

    // // On clicking stop/scan
    onClick() {
      console.log("Toggle Value :"+this.props.isToggled)
      if(!this.props.isToggled){
        this.startScan();
      }else {
        this.stopScan();
      }
    }

    // Clear the data source 
    onClearPressed(){
      this.props.removeScanResult();
      console.log("Clear Tapped");
      bridgeReact.clearScanList();
    }

    stopScanning() {
      bridgeReact.stopScan();
      this.props.stopScan();
      this.removeSubscription();
      subscription = scanningEmitter.addListener(
        'ScannedResult',
        (scanResultObj) => { // On Callback update data source
          if(scanResultObj.errorMessage) 
          {
            this.stopScan();
            Alert.alert(scanResultObj.errorMessage);
            
          }else {
            this.performOpearationBasedOnCallbackType(scanResultObj);
          }
        }
        );
    }


    render() {
      const { navigate } = this.props.navigation;
      return (
        <View style={styles.container}>
          <View style={styles.container1}>
            <Button  style={styles.button}
              onPress={() => {this.onClick()}}
              title = {this.props.buttonTitle}
              color= "#000" >
            </Button>
            <Button style={styles.button}
              onPress={() => {this.onClearPressed()}}
              title = 'Clear'
              color= "#000" >
            </Button>
         </View>
          <DeviceListView deviceList={this.props.scannedResultArray} stopScan={()=>this.stopScanning()} ></DeviceListView> 
        </View>
      );
    }
  }

  export default Home;
  