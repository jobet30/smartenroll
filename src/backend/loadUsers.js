import wixData from 'wix-data';
import { ok, notFound, serverError} from 'wix-http-functions';

export function getUsers(){
  return wixData.query('User')
    .find()
    .then(users => ok(users){
      if(users.length > 0){
        return ok(users.items);
      } else {
        return notFound('No users found');
      }
    })
    .catch((error) => {
      console.error('Error querying Users collection: ', error);
      return serverError('Error querying Users collection');
    });
}