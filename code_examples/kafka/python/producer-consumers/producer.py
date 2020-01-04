from time import sleep
from json import dumps
from kafka import KafkaProducer

# First we initialize the new Kafka Producer

#bootstrap_servers=[‘localhost:9092’]: 
# sets the host and port the producer should contact to bootstrap initial cluster metadata.
#  It is not necessary to set this here, since the default is localhost:9092.

#value_serializer=lambda x: dumps(x).encode(‘utf-8’): 
# function of how the data should be serialized before sending to the broker.
# Here, we convert the data to a json file and encode it to utf-8.


producer = KafkaProducer(bootstrap_servers=['kafka2:9095'],
                         value_serializer=lambda x: 
                         dumps(x).encode('utf-8'))


for e in range(1000):
    data = {'number' : e}
    producer.send('numtest',topic='python-topic' , value=data)
    sleep(5)
