import React from 'react';
import PropTypes from 'prop-types';
import { View, ListView, StyleSheet, Text } from 'react-native';
import Row from './RowForList';

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
  });

  class DeviceListView extends React.Component {
    constructor(props) {
      super(props);
      const ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
      this.state = {
        db:props.deviceList,
        dataSource: ds.cloneWithRows(props.deviceList),
      };
    }
    
    componentWillReceiveProps(props)
    {
        this.setState({
                dataSource: this.state.dataSource.cloneWithRows(this.props.deviceList)
        });
    }

    onRowPressed (data) {
      this.props.stopScan(data);
    }
   
    render() {
      return (
        <ListView
          style={styles.container}
          dataSource={this.state.dataSource}
          renderRow={(data) => <Row data={data} stopScan1 = {(data)=>{this.onRowPressed(data)}} />}
          renderSeparator = {
            (sectionId,rowId) => <View key={rowId} style={styles.separator }/>
          }
          enableEmptySections = {true}  
        />
      );
    }
  }

  DeviceListView.propTypes = {
    stopScan:PropTypes.func,
  };
  
export default DeviceListView;