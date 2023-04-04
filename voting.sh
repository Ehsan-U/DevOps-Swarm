# -- vote
# *intro*: frontend for users to take inputs
docker network create --driver overlay frontend_network
docker service create --detach --name vote -p 80:80 --network frontend_network --replicas 2 bretfisher/examplevotingapp_vote

# -- redis
# *intro*:store results in key-value
docker service create --detach --name redis --network frontend_network --replicas 1 redis:3.2

# -- worker
# *intro*: take results from redis and store to postgres
docker network create --driver overlay backend_network
docker service create --detach --name db --network backend_network --mount type=volume,source=db-data,target=/var/lib/postgresql/data --replicas 1 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:9.4

# -- result
# *intro*: shows results to admin
docker service create --detach --name result --network backend_network -p 5005:80 --replicas 1 bretfisher/examplevotingapp_result
