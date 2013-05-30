require File.expand_path('../lib/requests', File.dirname(__FILE__))

test "basic auth" do
  r = Requests.get("http://httpbin.org/basic-auth/u/p", auth: ['u', 'p'])

  assert_equal r.json["authenticated"], true
  assert_equal r.json["user"], "u"
end

test "GET" do
  r = Requests.get("http://httpbin.org/get", params: { foo: "bar" })

  assert_equal 200, r.status_code
  assert_equal ["application/json"], r.headers["content-type"]
  assert_equal "UTF-8", r.encoding.to_s

  assert(r.json["args"] && r.json["args"]["foo"] == "bar")
end

test "POST data" do
  r = Requests.post("http://httpbin.org/post", data: '{ "plan": "test" }')

  assert_equal 200, r.status_code
  assert_equal ["application/json"], r.headers["content-type"]
  assert_equal "UTF-8", r.encoding.to_s

  assert(r.json["json"]  && r.json["json"] == { "plan" => "test" })
end

test "PUT data" do

end

test "POST params" do
  payload = [
    ['a[]', 'a1'],
    ['a[]', 'a2'],
    ['b', '3'],
    ['c', '4']
  ]

  r = Requests.post("http://httpbin.org/post", data: payload)

  assert_equal 200, r.status_code

  form = r.json["form"]

  assert_equal form['a[]'], ['a1', 'a2']
  assert_equal form['b'], '3'
  assert_equal form['c'], '4'
end
