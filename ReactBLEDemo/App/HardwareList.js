import React from 'react';
import { View, ListView, StyleSheet, Text,TouchableHighlight, Image,Alert } from 'react-native';
import HardwareDetails from './../App/HardwareDetails'
import { StackNavigator } from 'react-navigation';


class HardwareList extends React.Component {
    constructor(props) {
      super(props);
      const ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
      this.state = {
        dataSource: ds.cloneWithRows(this.props.data),
      };
      console.log(this.props.data)
    }
    render() {
      return (
        <ListView
          style={styles.container}
          dataSource={this.state.dataSource}
          renderRow={(data)=> <HardwareCell navigation = {this.props.navigation}/>}
          renderSeparator = {
            (sectionId,rowId) => <View key={rowId} style={styles.separator }/>
          }
          enableEmptySections = {true}  
        />
      );
    }
  }

  class HardwareCell extends React.Component 
  {

    onPress() {
        this.props.navigation.navigate("HardwareDetails", {screen: HardwareDetails})
    }

    render(){
      return(
        <TouchableHighlight onPress={() =>{this.onPress()}} >
            <View style={styles.hardwareCellContainer}>
                <Image source={(require('./Images/bulbIcon.png'))} style={styles.photo}/>
                <View style={styles.hardwareCellContainer1}>
                    <Text style={styles.text}>Device Name : Blood Presure</Text>
                    <Text style={styles.text1}>UUID : 58923512536595623</Text>
                </View>
            </View>
            
        </TouchableHighlight>      
      )
    }
}

  const styles = StyleSheet.create({
    container: {
      flex: 1,
      // marginTop: 20,
      backgroundColor:'white'
    },
    separator: {
      flex: 1,
      height: StyleSheet.hairlineWidth,
      backgroundColor: '#8E8E8E',
    },
    hardwareCellContainer: {
      flex: 1,
      padding: 12,
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent:'space-between',
      height:110
    },
    hardwareCellContainer1: {
        flex: 1,
        flexDirection: 'column',
        justifyContent:'space-between',
        padding: 12,
    },
    text: {
        marginLeft: 12,
        fontSize: 16,
    },
    text1: {
          marginLeft: 12,
          fontSize: 13,
    },
    photo: {
        height: 40,
        width: 40,
        borderRadius: 20,
    }
  });
  
export default HardwareList;