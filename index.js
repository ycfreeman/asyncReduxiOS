// import 'babel-polyfill'
// import React from 'react'
// import { render } from 'react-dom'
// import { Provider } from 'react-redux'
// import App from './containers/App'
import { fetchPostsIfNeeded } from './actions'
import configureStore from './store/configureStore'

const store = configureStore()

function update(){
    console.log(store.getState());
}

function fetchPosts(reddit) {
    store.dispatch(fetchPostsIfNeeded(reddit || 'reactjs'));
}

store.subscribe(update);

window.fetchPosts = fetchPosts;