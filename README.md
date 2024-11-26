### Feed processor

The Task:

Write a program that
1. Parses the product feed XML file above
2. For each product, extracts the id, title and description
3. Batches them together and calls the provided external service for each batch

A batch should

1. Be a JSON encoded array of the form:
[{id: 'id', title: 'title', description: 'description'}, ...]
2. As close to as possible, but strictly below 5 megabytes in size

### How to run

```bash
docker build -t product-feed-processor .
docker run --rm -v $(pwd)/feed.xml:/usr/src/app/feed.xml product-feed-processor
```
