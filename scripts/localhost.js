import { group, check, sleep } from "k6";
import http from "k6/http";

export let options = {
  thresholds: {
    'http_req_duration{kind:html}': ["avg<=10"],
    'http_req_duration{kind:css}': ["avg<=10"],
    'http_req_duration{kind:img}': ["avg<=100"],
    'http_reqs': ["rate>100"],
  },
  "vus": 100,
  "duration": "2m"
};

export default function() {
  let res = http.get("http://192.168.23.55:7423/search/key/500/service.%25");
    check(res, {
        "is status 200": (r) => r.status === 200
    });
    sleep(3);
  group("all Services", () => {
    let res = http.get("http://192.168.23.55:7423/search/key/500/service.%25live%25");
    let jres = JSON.parse(res.body);
    check(res, {
      "is status 200": (r) => r.status === 200,
      "is key correct": (r) => jres[1].key != ""
    });
  });
  group("all HELLO service entrys", () => {
    let res = http.get("http://192.168.23.55:7423/search/key/500/service.hello%25");
    let jres = JSON.parse(res.body);
    check(res, {
      "is status 200": (r) => r.status === 200,
      "is key correct": (r) => jres[1].key != ""
    });
  });
  group("all live services", () => {
    let res = http.get("http://192.168.23.55:7423/search/key/500/service.%25live%25");
    let jres = JSON.parse(res.body);
    check(res, {
      "is status 200": (r) => r.status === 200,
      "is key correct": (r) => jres[1].key != ""
    });
  });    
}