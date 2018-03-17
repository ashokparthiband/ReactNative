import React from 'react';
import { StackNavigator } from 'react-navigation';



import {View,Text,Button,StyleSheet} from 'react-native';

export default class NumberCounter extends React.Component {

    constructor(props) {
        super(props)
    }

    static navigationOptions = ({navigation}) => ({
        title: "Counter",
        headerTitleStyle:{
          fontSize:24,
          alignSelf:'center'
        } 
      });

    render (){
        return(
            <View style={styles.container}>
                <Button
                    onPress = {this.props.increment}
                    title = "++"
                    color = "#841584"
                    accessibilityLabel="Increase Count"
                />
                <Text style={styles.textStyle} >{this.props.count}</Text>
                <Button
                    onPress = {this.props.decrement}
                    title = "--"
                    color = "#841584"
                    accessibilityLabel="Decrease Count"
                />
                <Text style={styles.textStyle}>
                    {this.props.tappedButtonName}
                </Text>
            </View>
        );
    }
} 

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    textStyle: {
        fontSize:20
    }
});