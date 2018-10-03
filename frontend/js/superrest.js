const getIt = (url,data,callback) => {
  superagent('get',url).then( (res) => {
    callback(res.body);
  });
};

const postIt = (url,data,callback) => {
  superagent.post(url).set('Content-Type', 'application/json').send(data).then( callback );
};

const getAll = (callback) => {
  getIt('/api/get/all',{},callback);
};

const testPost = (callback) => {
  postIt('/api/post',{title:'hello world',text:'this is a test please hold the line the next agent will be ready soon'}, callback);
};