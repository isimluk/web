import posthog from 'posthog-js';

posthog.init('phc_1kR0B0FKHGH5XRkfVOCYx7bJYyP47zN3wdyNrDCLn1f', {
  api_host: 'https://metrics.trento.suse.com',
});

export const capture = (event, payload) => posthog.capture(event, payload);
