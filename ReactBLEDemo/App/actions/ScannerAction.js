import {connect} from 'react-redux';
import * as Actions from './ActionTypes';

import Home from './../../Screens/Home';

const mapStateToProps = (state) => ({
    scannedResultArray:state.ScannerReducer.scannedResultArray,
    isToggled:state.ScannerReducer.isToggled,
    buttonTitle:state.ScannerReducer.buttonTitle,
    deviceList:state.ScannerReducer.deviceList,
})

const mapDispatchToProps = (dispatch) => ({
    startScan:()=>dispatch({type:Actions.START_SCAN}),
    stopScan:()=>dispatch({type:Actions.STOP_SCAN}),
    addScanResult : (scanResult) => dispatch({type:Actions.ADD_SCAN_RESULT,scanResult}),
    removeScanResult: () => dispatch({type:Actions.REMOVE_SCAN_RESULT}),
    updateScanResult : (scanResult) => dispatch({type:Actions.UPDATE_SCAN_RESULT,scanResult}),
    addDevice:(scanResult) => dispatch({type:Actions.ADD_DEVICE,scanResult})
})

export default connect(mapStateToProps,mapDispatchToProps)(Home);