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
      title: "Devices",
      headerTitleStyle:{
        fontSize:24,
        alignSelf:'center'
      },
      // headerRight:
      // <Button
      //   onPress={() => navigation.navigate("Scan", {screen: "ScanWindow"})}
      //   title = "Next"
      //   color= "#000" >
      // </Button>   
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
            Alert.alert(scanResultObj.errorMessage);
            this.stopScan();
          }else {
            if(this.props.scannedResultArray.length >= 1000) // Add only 1000 records
            {
              subscription.remove(); // Remove listener
              console.log("Subscription Removed!");
            }else {
              this.props.addScanResult(scanResultObj);
            }
          }
          
        }
        );
        bridgeReact.scanForDevices(); // Call native scan 
    }

    // On clicking stop scan
    stopScan(){
        console.log('STOP SCAN');
        bridgeReact.stopScan();
        // this.setState({isToggled:false})
        this.props.stopScan();
        if(subscription)subscription.remove();
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
          <DeviceListView deviceList={this.props.scannedResultArray}></DeviceListView> 
        </View>
      );
    }
  }

  export default Home;
  