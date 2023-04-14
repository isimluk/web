import posthog from 'posthog-js';

import config from '@lib/config';

const installationID = config.get('installationID');

posthog.init('phc_1kR0B0FKHGH5XRkfVOCYx7bJYyP47zN3wdyNrDCLn1f', {
  api_host: 'https://metrics.trento.suse.com',
});

export const capture = (event, payload) => {
  posthog.capture(event, { ...payload, installationID });
};
