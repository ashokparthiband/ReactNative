import React from 'react';
import { View, ListView, StyleSheet, Text, Button } from 'react-native';
import Home from './Home'
import ScannerAction from './../App/actions/ScannerAction'
import { StackNavigator } from 'react-navigation';
import HardwareList from './../App/HardwareList'



class Hardwares extends React.Component<Props> {

    static navigationOptions = ({navigation}) => ({
        title: "Hardwares",
        headerTitleStyle:{
            fontSize:24,
            alignSelf:'center'
          },
        headerRight:
            <Button
                onPress={() => navigation.navigate("Scanner", {screen: ScannerAction})}
                title = "Scan"
                color= "#000" >
            </Button>   
      });

    render() {
      return (
        <View style={styles.container}>
            <HardwareList data = {localData} navigation = {this.props.navigation}/>
        </View>
      );
    }
  }

  const styles = StyleSheet.create({
    container: {
      backgroundColor: '#eff042',
      flex: 1,
      flexDirection: 'column',
    }
  });


  export default Hardwares;

  const localData = [
      {"Hai":"How are you?"}
  ]