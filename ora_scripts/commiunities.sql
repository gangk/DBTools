UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/activityservice/api/story/v1/activities' WHERE propname='DocumentFileName';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1' WHERE propname = 'PATHWAYS_REMOTE_SERVER_URL';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/portal/server.pt/gateway/PTARGS_0_394_240_0_0_43/http%3B/adc4120092.us.oracle.com%3B11960/graffiti/api/' WHERE propname = 'PATHWAYS_GATEWAY_PATH';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/portal/server.pt/gateway/PTARGS_0_394_240_0_0_43/http%3B/adc4120092.us.oracle.com%3B11960/graffiti/faces/pages/userpages/enhanced.xhtml' WHERE propname = 'PATHWAYS_FULL_PATH';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1' WHERE propname = 'STATIC_CONTENT_SERVER';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/imageserver/' WHERE propname = 'InternalImageserverURI';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/metalink-portlets/pages/portlet.jsf' WHERE propname = 'iFrameURL';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/imageserver/' WHERE propname = 'imageServerBaseURL';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/portal/server.pt/gateway/PTARGS_0_0_369_2_0_43/http%3B/adc4120092.us.oracle.com%3B7005/metalink-portlets/metalinkaggregator/pages/rss/rssSubscribedDocumentsFeed.jsf' WHERE propname = 'RSS_FULL_PATH';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/portal/server.pt' WHERE propname = 'URL_TO_PORTAL';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = '<link href="https://&1/imageserver/plumtree/portal/custom/supportcommunities/css/main_adaptive.css" rel="stylesheet" type="text/css" />' WHERE propname = 'KM_CSS_LINK';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/portal/server.pt/gateway/PTARGS_0_0_275_412_187442_43/http%3B/adc4120092.us.oracle.com%3B7005' WHERE propname = 'SESDocUrlPrefix';
UPDATE ANAND.COMMUNITIES_SETTINGS SET PROPVALUE = 'https://&1/portal/server.pt/gateway/PTARGS_0_0_340_250_59357_43/http%3B/adc4120092.us.oracle.com%3B7005/collab/docman/download/' WHERE propname = 'CAPT_IMAGE_URL_PREFIX';
commit;
