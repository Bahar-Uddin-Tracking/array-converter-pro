___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Array Converter Pro",
  "description": "A flexible GTM variable that converts ecommerce item arrays into platform-specific formats for powerful tracking and remarketing.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "CHECKBOX",
    "name": "checkboxdropDown",
    "checkboxText": "Yes",
    "simpleValueType": true,
    "displayName": "Do you want to convert the array according to the platform?"
  },
  {
    "type": "SELECT",
    "name": "dropDownMenu",
    "selectItems": [
      {
        "value": "facebook",
        "displayValue": "Facebook"
      },
      {
        "value": "ga4",
        "displayValue": "GA4"
      },
      {
        "value": "pinterest",
        "displayValue": "Pinterest"
      },
      {
        "value": "snapchat",
        "displayValue": "Snapchat"
      },
      {
        "value": "tiktok",
        "displayValue": "Tiktok"
      }
    ],
    "simpleValueType": true,
    "displayName": "Choose your platform",
    "help": "You get the array for an items or contents parameter as recommended by your platform",
    "enablingConditions": [
      {
        "paramName": "checkboxdropDown",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "checkbox",
    "checkboxText": "Yes",
    "simpleValueType": true,
    "displayName": "Do you want to work across multiple products?",
    "enablingConditions": [
      {
        "paramName": "checkboxdropDown",
        "paramValue": false,
        "type": "EQUALS"
      }
    ],
    "help": "You will get an array for multiple products content_ids or content_name parameters EX: [\u00272050\u0027, \u00272593\u0027] or [\u0027Blue Denim Jeans\u0027, \u0027Light Brown Purse\u0027]"
  },
  {
    "type": "RADIO",
    "name": "radioButtonGroup",
    "displayName": "Choose one",
    "radioItems": [
      {
        "value": "item_id",
        "displayValue": "Item ID"
      },
      {
        "value": "item_name",
        "displayValue": "Item Name"
      },
      {
        "value": "itemlength",
        "displayValue": "Num of Items"
      }
    ],
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "checkbox",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "remarketing",
    "checkboxText": "Yes",
    "simpleValueType": true,
    "displayName": "Do you need google ads dynamic remarketing array?",
    "enablingConditions": [
      {
        "paramName": "checkbox",
        "paramValue": false,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const copyFromDataLayer = require('copyFromDataLayer');
const log = require('logToConsole');
const string = require('makeString');
const number = require('makeNumber');

let dropDownMenu = data.dropDownMenu;
let checkbox = data.checkbox;
let radioButton = data.radioButtonGroup;
let checkboxdropDown = data.checkboxdropDown;
let remarketing = data.remarketing;

const ecommerce = copyFromDataLayer('ecommerce') || copyFromDataLayer('eventModel');

if (ecommerce && ecommerce.items && ecommerce.items.length > 0) {

  if (checkbox) {
    const values = [];
    let itemsNumber = 0;

    for (let i = 0; i < ecommerce.items.length; i++) {
      const product = ecommerce.items[i];
      
      if (radioButton && product[radioButton] !== undefined) {
        values.push(string(product[radioButton]));
      }
    }

    if (radioButton === 'itemlength') {
      itemsNumber = number(ecommerce.items.length);
      return itemsNumber;
    }

    return values;
  }

  else if (checkboxdropDown || remarketing || dropDownMenu) {
    const formattedItems = [];

    for (let i = 0; i < ecommerce.items.length; i++) {
      const product = ecommerce.items[i];
      let formatted = {};

      if (dropDownMenu === 'facebook') {
        formatted = {
          id: string(product.item_id) || string(product.id),
          item_price: number(product.price),
          quantity: number(product.quantity) || 1
        };
      } else if (dropDownMenu === 'tiktok') {
        formatted = {
          content_id: string(product.item_id) || string(product.id),
          content_name: product.item_name || product.name,
          price: number(product.price),
          quantity: number(product.quantity) || 1
        };
      } else if (dropDownMenu === 'pinterest') {
        formatted = {
          product_id: string(product.item_id) || string(product.id),
          product_name: product.item_name || product.name,
          product_price: number(product.price),
          product_quantity: number(product.quantity) || 1
        };
      } else if (dropDownMenu === 'snapchat') {
        formatted = {
          id: string(product.item_id) || string(product.id),
          item_price: number(product.price),
          quantity: number(product.quantity) || 1
        };
      } else if (dropDownMenu === 'ga4') {
        formatted = {
          item_id: string(product.item_id) || string(product.id),
          item_name: product.item_name || product.name,
          price: number(product.price),
          quantity: number(product.quantity) || 1
        };
      } else if (remarketing) {
        formatted = {
          id: string(product.item_id) || string(product.id),
          google_business_vertical: 'retail'
        };
      } else {
        formatted = product;
      }

      formattedItems.push(formatted);
    }

    return formattedItems;
  }
}

return [];


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 6/23/2025, 8:26:41 PM


