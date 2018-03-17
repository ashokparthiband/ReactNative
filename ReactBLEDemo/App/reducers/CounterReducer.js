import * as Actions from './../actions/ActionTypes'

const CounterReducer = (state = {
    count:0,
    tappedButtonName:""
    },action) => {
    switch(action.type) {
        case Actions.COUNTER_INCREMENT:
            return Object.assign({},state,{
                count:state.count+1,
                tappedButtonName:"Incrementing"
            });
        case Actions.COUNTER_DECREMENT:
            return Object.assign({},state,{
                count:state.count-1,
                tappedButtonName:"Decrementing"
            })
        default:
            return state;
    }
}

export default CounterReducer;