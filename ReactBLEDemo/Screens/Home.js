import React from 'react';
import { View, ListView, StyleSheet, Text ,TouchableHighlight,Button,titleStyle} from 'react-native';
import CustomListView from './../App/CustomListView';
import { StackNavigator } from 'react-navigation';
import {NativeModules,NativeEventEmitter} from 'react-native';
import DeviceListView from './../App/DeviceListView'

let bridgeReact = NativeModules.BirdgeReact;

const { BridgeReactEmitter } = NativeModules;

const scanningEmitter = new NativeEventEmitter(BridgeReactEmitter);

const subscription = undefined;

class Home extends React.Component<Props> {

    constructor(){
      super();
      this.state = {
          textValue:'Change me',
          scannedResultArray : [],
          scannedResult1:[],
          isToggled: false,
      }
    }

    static navigationOptions = ({navigation}) => ({
      title: "Devices",
      headerTitleStyle:{
        fontSize:24,
        alignSelf:'center'
      }   
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
        subscription.remove();
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


  const styles = StyleSheet.create({
    container: {
      backgroundColor: '#eff0f2',
      flex: 1,
      flexDirection: 'column',
      // justifyContent: 'center',
    },
    container1: {
      backgroundColor: '#eff0f2',
      flexDirection: 'row',
      height:60,
      alignItems: 'center',
      justifyContent:'space-around'
    },
    containerListView: {
      flex: 1,
      backgroundColor:'white'
    },
    text:{
      fontSize: 30,
      textAlign: 'center'
    },
    titleView:{
      marginTop: 30,
      backgroundColor:'#eff0f2'
    },
    button: {
      marginBottom: 0,
      fontSize:20,
      alignItems: 'center',
      height:40
    },
    buttonText: {
      padding: 20,
      color: 'white'
    },
    actionButton: {
      padding:10,
      alignItems: 'center',
    }
  });

  export default Home;


  // headerRight:
  //     <Button
  //       onPress={() => navigation.navigate("Scan", {screen: "ScanWindow"})}
  //       title = "Scan"
  //       color= "#000" >
  //     </Button>

  {/* <Button
        onPress={() => {
            bridgeReact.addEvent("Hai","Location")
          }}
        title = "Scan"
        color= "#000"
         /> */}


        //  onPress={() => {
        //   bridgeReact.scanForDevices((error, events) => {
        //   if (error) {
        //     console.error(error);
        //   } 
        //   else {
        //     console.log("\n============ \n Device Name :"+events.deviceName);
        //   }
        //   });
        // }}