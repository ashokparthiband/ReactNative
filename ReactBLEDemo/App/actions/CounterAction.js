import {connect} from 'react-redux';
import * as Actions from './ActionTypes';

import NumberCounter from './../NumberCounter';

const mapStateToProps = (state) => ({
    count:state.CounterReducer.count,
    tappedButtonName:state.CounterReducer.tappedButtonName
});

const mapDispatchToProps = (dispatch) => ({
    increment : () => dispatch({type:Actions.COUNTER_INCREMENT}),
    decrement : () => dispatch({type:Actions.COUNTER_DECREMENT})
});

export default connect (mapStateToProps,mapDispatchToProps)(NumberCounter);