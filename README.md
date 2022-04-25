### Steps to run this sample:


1. Use this repository as template
2. Log in to [Tailscale](https://tailscale.com)
3. Generate an [auth key](https://login.tailscale.com/admin/settings/keys)
4. Deploy the temporal cluster on render using the button below.
5. It should ask you to enter the `TAILSCALE_AUTHKEY` environment variable in `render-subnet-router` service. If not go the concerned service and add it manually and restart the service manually.
6. Navigate to your [tailscale dashboard](https://login.tailscale.com/admin/machines) you should see a `render-subnet-router` machine.
7. Click on the machine
8. Click on the review button in the subnets section and toggle the subnet route.
9. If for any reason the blueprints sync failed, do not hesitate to manually sync the blueprints. Same for the database, if it takes too long to deploy, delete and re-sync the blueprint.
10. Navigate the the temporal frontend service in render.com and copy the service address (without the port) `temporal-frontend-ul3u`
11. Get the temporal-frontend IP by navigating the render-subnet-router service in render.com then click shell and wait, once the shell is up `dig temporal-frontend-ul3u`, you should get the IP address
12. Then in `src/worker.ts` and `src/client.ts` replace the IP address by the one you have found in step 11.
13. Build the app using docker ` docker build -t temporal-samples-typescript:latest .`
14. Then run it `docker run  --rm -it --name typescript-samples -e TAILSCALE_AUTHKEY=YOUR_TAILSCALE_AUTHKEY  temporal-samples-typescript:latest`
15. Observe that the worker timeout to connect






[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

