// import 'babel-polyfill'
// import React from 'react'
// import { render } from 'react-dom'
// import { Provider } from 'react-redux'
// import App from './containers/App'
import _ from 'lodash'
import { fetchPostsIfNeeded } from './actions'
import configureStore from './store/configureStore'

var JSItem = window.JSItem || {};

const store = configureStore();

window.sections = {};

function update(){
    let sections = window.sections;
    let data = store.getState().postsByReddit;

    _.forEach(data, (value, key) => {
        sections[key] = _.union(
            sections[key],
            _.map(value.items, (item, index) => {
                return JSItem.createWithIdStrInt(index, item.domain, index);
            })
        );

        JSItem.emitSectionItems(key, sections[key]);
    });

    console.log(sections);
    window.sections = sections;
}

function render() {
    _.forEach(window.sections, (value, key) => {
        JSItem.emitSectionItems(key, value);
    })
}

function dispatchFetchPostsIfNeeded(reddit) {
    store.dispatch(fetchPostsIfNeeded(reddit || 'reactjs'));
}

var count = 0;


function fetchMorePosts() {
  if (count == 0) {
     fetchPosts('reactjs');
  } else if (count == 1) {
     fetchPosts('facebook');
  } else if (count == 2) {
     fetchPosts('angularjs');
  }
  count += 1;
}

store.subscribe(update);

window.fetchPosts = dispatchFetchPostsIfNeeded;
window.fetchMorePosts = fetchMorePosts;
window.render = render;