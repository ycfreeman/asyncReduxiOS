// import 'babel-polyfill'
// import React from 'react'
// import { render } from 'react-dom'
// import { Provider } from 'react-redux'
// import App from './containers/App'
import { fetchPostsIfNeeded } from './actions'
import configureStore from './store/configureStore'

var JSItem = window.JSItem || {};

const store = configureStore();

function update(){
    let data = store.getState().postsByReddit;

    for (var groupName in data) {
        if (!data.hasOwnProperty(groupName)) {
            continue;
        }
        let group = data[groupName];
        JSItem.emitSectionItems(groupName, group.items.map((item, index) => {
            return JSItem.createWithIdStrInt(index, item.domain, index)
        }));
    }
}

function fetchPosts(reddit) {
    store.dispatch(fetchPostsIfNeeded(reddit || 'reactjs'));
}

store.subscribe(update);

window.fetchPosts = fetchPosts;
