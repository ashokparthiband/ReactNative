import React from 'react';
import { View, ListView, StyleSheet, Text ,TouchableHighlight,Button,titleStyle} from 'react-native';
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
        this.setState({isToggled:true})
        subscription = scanningEmitter.addListener(
          'ScannedResult',
          (scanResultObj) => { // On Callback update data source
            if(this.state.scannedResultArray.length >= 1000) // Add only 1000 records
            {
              this.setState({
                scannedResult1 : [...this.state.scannedResult1,this.state.scannedResultArray] // Add the result to array
              })
              subscription.remove(); // Remove listener
            }else {
              this.setState({
                scannedResultArray : [...this.state.scannedResultArray,scanResultObj]
              })
              if(!this.state.isDataSourceSet){
                this.setState({
                  isDataSourceSet:true
                })
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
        this.setState({isToggled:false})
        if(subscription)subscription.remove();
    }

    // // On clicking stop/scan
    onClick() {
      
      if(!this.state.isToggled){
        this.startScan();
      }else {
        this.stopScan();
      }
    }

    // Clear the data source 
    onClearPressed(){
      this.setState({
        scannedResultArray:[]
      });
    }


    render() {
      const { navigate } = this.props.navigation;
      return (
        <View style={styles.container}>
          <View style={styles.container1}>
            <Button  style={styles.button}
              onPress={() => {this.onClick()}}
              title = {this.state.isToggled?'Stop':'Scan'}
              color= "#000" >
            </Button>
            <Button style={styles.button}
              onPress={() => {this.onClearPressed()}}
              title = 'Clear'
              color= "#000" >
            </Button>
         </View>
          <DeviceListView deviceList={this.state.scannedResultArray}></DeviceListView> 
        </View>
      );
    }
  }

  export default Home;
  