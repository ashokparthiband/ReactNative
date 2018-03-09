import React from 'react';
import { View, Text, StyleSheet, Image ,TouchableHighlight,Alert} from 'react-native';

const styles = StyleSheet.create({
    container: {
      flex: 1,
      padding: 12,
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent:'space-between',
      height:110
    },
    text: {
      marginLeft: 12,
      fontSize: 16,
    },
    text1: {
        marginLeft: 12,
        fontSize: 13,
      },
    text2: {
        marginLeft: 12,
        fontSize: 11,
      },
    photo: {
      height: 40,
      width: 40,
      borderRadius: 20,
    },
    
  });

  

  class Row extends React.Component {

    onPress() {
      Alert.alert('Packet Info',"Device : ".toUpperCase()+this.props.data.deviceName+"\n RSSI:"+this.props.data.RSSI+"\n Adv Data:\n".toUpperCase()+this.props.data.AdvData);
    }

    render(){
      return(
        <TouchableHighlight onPress={() =>{this.onPress()}} >
        <View style={styles.container}>
        <Image source={(require('./Images/bulbIcon.png'))} style={styles.photo}/>
        <View style={{flex: 1,flexDirection: 'column',justifyContent:'space-between'}}> 
        <Text style={styles.text}> 
          {'Device :'}{this.props.data.deviceName}
        </Text>
        <Text style={styles.text}> 
            RSSI : {this.props.data.RSSI}
        </Text>
        <Text style={styles.text1}>
            Adv Data : {this.props.data.AdvData}
        </Text>
        <Text style={styles.text2}>
            Received At : {this.props.data.receivedAt}
        </Text>
       </View>  
       </View>       
        </TouchableHighlight>      
      )
    }
  }
  
  export default Row;

  // <Text style={styles.text}> Device
  //           {`${props.deviceName}`} RSSI {`${props.RSSI}`}
  //       </Text>
  //       <Text style={styles.text1}>
  //           {`${props.AdvData}`}
  //       </Text>
   