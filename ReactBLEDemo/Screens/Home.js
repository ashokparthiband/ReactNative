import React from 'react';
import { View, ListView, StyleSheet, Text ,TouchableHighlight,Button,titleStyle} from 'react-native';
import CustomListView from './../App/CustomListView';
import { StackNavigator } from 'react-navigation';
import {NativeModules} from 'react-native';

let bridgeReact = NativeModules.BirdgeReact;

class Home extends React.Component<Props> {

    // var doScanning = (error,scanResult) => ()
    // {
    //   if (error) {
    //     console.error(error);
    //   } else {
    //     console.log("\n============ \n Device Name :"+scanResult.deviceName);
    //   }
    // }

    static navigationOptions = ({navigation}) => ({
      title: "Devices",
      headerTitleStyle:{
        fontSize:24,
        alignSelf:'center'
      },
      headerRight:
      <Button
        onPress={() => {
            bridgeReact.scanForDevices((error, events) => {
            if (error) {
              console.error(error);
            } 
            else {
              console.log("\n============ \n Device Name :"+events.deviceName);
            }
});
          }}
        title = "Scan"
        color= "#000" >
      </Button>
    });


    render() {
      const { navigate } = this.props.navigation;
      return (
        <View style={styles.container}>
        
        <CustomListView></CustomListView>

        </View>
      );
    }
  }

  const styles = StyleSheet.create({
    container: {
      backgroundColor: '#eff0f2',
      flex: 1,
      flexDirection: 'column',
    },
    text:{
      fontSize: 30,
      textAlign: 'center'
    },
    titleView:{
      marginTop: 30,
      backgroundColor:'#eff0f2'
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