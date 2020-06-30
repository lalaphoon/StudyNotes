# Mimi Instagram Web App

Mimi instragram is a mimic of instagram web app that allows users to upload video or image. Users can also see nearby posts - video or images around him or her.

[Frontend](###frontend) - cloud and React based social Network

* Used [React JS](####reactjs-components) framework to implement a social network (create/view posts, search, profile etc.)
* Implemented basic **token based** registration/login/logout flow with **React Router v4** and server-size user authentication with **JWT**.
* Used **Ant Design, GeoLocation API and Google Map API** to improve the user experience.

[Backend](###backend) - geo-index and Image Recognization based social network

* Designed and implemented a scalable web service in **Go** to handle posts and deployed to **Google Cloud (GKE)** for better scaling.
* Used [**ElasticSearch(GCE)**](###elasticsearch) to provide geo-location based search function
* Used **Google Cloud Vision API** to predict faces in images posts by users.



### Frontend

#### ReactJS components



### Backend

#### main.go

* Defined structure of post and location

  ​	Location: {lat : float64, lon : float64}

  ​	Post: {user: string, message: string, location: Location, url:string, type:string, face:float32}

* Let main handle "{host:port}/post" request

  * handlerPost() to decode the body of Post form
  * in main(), set up http.HandleFunc("/post", handlerPost)

* **jwtmiddleware** - let service covered by token based authentication

#### index.go

> Communicate to Elasticsearch GCE
>
> 创建table (index)， 建立schema，再插入测试数据



user.go

vision.go



### Elasticsearch

[reference](https://marutitech.com/elasticsearch-can-helpful-business/)

> Two Dimensional (k-dimensional) Range Search

Elasticsearch is an open source, distributed, RESTful search engine. As the heart of the Elastic Stack, it centrally stores your data so you can query the data quickly.

* We'll use Elasticsearch as our Database in our project to store Post related data.
* Build **GeoIndex** on Post locations to search geo based range search.

**Summary**

* Create Index
* Insert Data
* Retrieve Data
* Search

#### Terminologies

[reference](https://medium.com/@ashish_fagna/getting-started-with-elasticsearch-creating-indices-inserting-values-and-retrieving-data-e3122e9b12c6)

| MySQL (RDBMS) Terminology | ElasticSearch Terminology |
| ------------------------- | ------------------------- |
| Database                  | Index                     |
| Table                     | Type                      |
| Row                       | Document                  |

