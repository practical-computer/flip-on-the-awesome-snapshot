(function () {
  'use strict';

  function ownKeys(object, enumerableOnly) {
    var keys = Object.keys(object);

    if (Object.getOwnPropertySymbols) {
      var symbols = Object.getOwnPropertySymbols(object);
      enumerableOnly && (symbols = symbols.filter(function (sym) {
        return Object.getOwnPropertyDescriptor(object, sym).enumerable;
      })), keys.push.apply(keys, symbols);
    }

    return keys;
  }

  function _objectSpread2(target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = null != arguments[i] ? arguments[i] : {};
      i % 2 ? ownKeys(Object(source), !0).forEach(function (key) {
        _defineProperty(target, key, source[key]);
      }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)) : ownKeys(Object(source)).forEach(function (key) {
        Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key));
      });
    }

    return target;
  }

  function _defineProperty(obj, key, value) {
    if (key in obj) {
      Object.defineProperty(obj, key, {
        value: value,
        enumerable: true,
        configurable: true,
        writable: true
      });
    } else {
      obj[key] = value;
    }

    return obj;
  }

  function _toConsumableArray(arr) {
    return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread();
  }

  function _arrayWithoutHoles(arr) {
    if (Array.isArray(arr)) return _arrayLikeToArray(arr);
  }

  function _iterableToArray(iter) {
    if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter);
  }

  function _unsupportedIterableToArray(o, minLen) {
    if (!o) return;
    if (typeof o === "string") return _arrayLikeToArray(o, minLen);
    var n = Object.prototype.toString.call(o).slice(8, -1);
    if (n === "Object" && o.constructor) n = o.constructor.name;
    if (n === "Map" || n === "Set") return Array.from(o);
    if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen);
  }

  function _arrayLikeToArray(arr, len) {
    if (len == null || len > arr.length) len = arr.length;

    for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i];

    return arr2;
  }

  function _nonIterableSpread() {
    throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
  }

  function _createForOfIteratorHelper(o, allowArrayLike) {
    var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"];

    if (!it) {
      if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") {
        if (it) o = it;
        var i = 0;

        var F = function () {};

        return {
          s: F,
          n: function () {
            if (i >= o.length) return {
              done: true
            };
            return {
              done: false,
              value: o[i++]
            };
          },
          e: function (e) {
            throw e;
          },
          f: F
        };
      }

      throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
    }

    var normalCompletion = true,
        didErr = false,
        err;
    return {
      s: function () {
        it = it.call(o);
      },
      n: function () {
        var step = it.next();
        normalCompletion = step.done;
        return step;
      },
      e: function (e) {
        didErr = true;
        err = e;
      },
      f: function () {
        try {
          if (!normalCompletion && it.return != null) it.return();
        } finally {
          if (didErr) throw err;
        }
      }
    };
  }

  var _WINDOW = {};
  var _DOCUMENT = {};

  try {
    if (typeof window !== 'undefined') _WINDOW = window;
    if (typeof document !== 'undefined') _DOCUMENT = document;
  } catch (e) {}

  var _ref = _WINDOW.navigator || {},
      _ref$userAgent = _ref.userAgent,
      userAgent = _ref$userAgent === void 0 ? '' : _ref$userAgent;
  var WINDOW = _WINDOW;
  var DOCUMENT = _DOCUMENT;
  var IS_BROWSER = !!WINDOW.document;
  var IS_DOM = !!DOCUMENT.documentElement && !!DOCUMENT.head && typeof DOCUMENT.addEventListener === 'function' && typeof DOCUMENT.createElement === 'function';
  var IS_IE = ~userAgent.indexOf('MSIE') || ~userAgent.indexOf('Trident/');

  var _familyProxy, _familyProxy2, _familyProxy3, _familyProxy4, _familyProxy5;

  var NAMESPACE_IDENTIFIER = '___FONT_AWESOME___';
  var PRODUCTION = function () {
    try {
      return "production" === 'production';
    } catch (e) {
      return false;
    }
  }();
  var FAMILY_CLASSIC = 'classic';
  var FAMILY_SHARP = 'sharp';
  var FAMILIES = [FAMILY_CLASSIC, FAMILY_SHARP];

  function familyProxy(obj) {
    // Defaults to the classic family if family is not available
    return new Proxy(obj, {
      get: function get(target, prop) {
        return prop in target ? target[prop] : target[FAMILY_CLASSIC];
      }
    });
  }
  var PREFIX_TO_STYLE = familyProxy((_familyProxy = {}, _defineProperty(_familyProxy, FAMILY_CLASSIC, {
    'fa': 'solid',
    'fas': 'solid',
    'fa-solid': 'solid',
    'far': 'regular',
    'fa-regular': 'regular',
    'fal': 'light',
    'fa-light': 'light',
    'fat': 'thin',
    'fa-thin': 'thin',
    'fad': 'duotone',
    'fa-duotone': 'duotone',
    'fab': 'brands',
    'fa-brands': 'brands',
    'fak': 'kit',
    'fakd': 'kit',
    'fa-kit': 'kit',
    'fa-kit-duotone': 'kit'
  }), _defineProperty(_familyProxy, FAMILY_SHARP, {
    'fa': 'solid',
    'fass': 'solid',
    'fa-solid': 'solid',
    'fasr': 'regular',
    'fa-regular': 'regular',
    'fasl': 'light',
    'fa-light': 'light',
    'fast': 'thin',
    'fa-thin': 'thin'
  }), _familyProxy));
  var STYLE_TO_PREFIX = familyProxy((_familyProxy2 = {}, _defineProperty(_familyProxy2, FAMILY_CLASSIC, {
    solid: 'fas',
    regular: 'far',
    light: 'fal',
    thin: 'fat',
    duotone: 'fad',
    brands: 'fab',
    kit: 'fak'
  }), _defineProperty(_familyProxy2, FAMILY_SHARP, {
    solid: 'fass',
    regular: 'fasr',
    light: 'fasl',
    thin: 'fast'
  }), _familyProxy2));
  var PREFIX_TO_LONG_STYLE = familyProxy((_familyProxy3 = {}, _defineProperty(_familyProxy3, FAMILY_CLASSIC, {
    fab: 'fa-brands',
    fad: 'fa-duotone',
    fak: 'fa-kit',
    fal: 'fa-light',
    far: 'fa-regular',
    fas: 'fa-solid',
    fat: 'fa-thin'
  }), _defineProperty(_familyProxy3, FAMILY_SHARP, {
    fass: 'fa-solid',
    fasr: 'fa-regular',
    fasl: 'fa-light',
    fast: 'fa-thin'
  }), _familyProxy3));
  var LONG_STYLE_TO_PREFIX = familyProxy((_familyProxy4 = {}, _defineProperty(_familyProxy4, FAMILY_CLASSIC, {
    'fa-brands': 'fab',
    'fa-duotone': 'fad',
    'fa-kit': 'fak',
    'fa-light': 'fal',
    'fa-regular': 'far',
    'fa-solid': 'fas',
    'fa-thin': 'fat'
  }), _defineProperty(_familyProxy4, FAMILY_SHARP, {
    'fa-solid': 'fass',
    'fa-regular': 'fasr',
    'fa-light': 'fasl',
    'fa-thin': 'fast'
  }), _familyProxy4));
  var FONT_WEIGHT_TO_PREFIX = familyProxy((_familyProxy5 = {}, _defineProperty(_familyProxy5, FAMILY_CLASSIC, {
    900: 'fas',
    400: 'far',
    normal: 'far',
    300: 'fal',
    100: 'fat'
  }), _defineProperty(_familyProxy5, FAMILY_SHARP, {
    900: 'fass',
    400: 'fasr',
    300: 'fasl',
    100: 'fast'
  }), _familyProxy5));
  var oneToTen = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var oneToTwenty = oneToTen.concat([11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
  var DUOTONE_CLASSES = {
    GROUP: 'duotone-group',
    SWAP_OPACITY: 'swap-opacity',
    PRIMARY: 'primary',
    SECONDARY: 'secondary'
  };
  var prefixes = new Set();
  Object.keys(STYLE_TO_PREFIX[FAMILY_CLASSIC]).map(prefixes.add.bind(prefixes));
  Object.keys(STYLE_TO_PREFIX[FAMILY_SHARP]).map(prefixes.add.bind(prefixes));
  var RESERVED_CLASSES = [].concat(FAMILIES, _toConsumableArray(prefixes), ['2xs', 'xs', 'sm', 'lg', 'xl', '2xl', 'beat', 'border', 'fade', 'beat-fade', 'bounce', 'flip-both', 'flip-horizontal', 'flip-vertical', 'flip', 'fw', 'inverse', 'layers-counter', 'layers-text', 'layers', 'li', 'pull-left', 'pull-right', 'pulse', 'rotate-180', 'rotate-270', 'rotate-90', 'rotate-by', 'shake', 'spin-pulse', 'spin-reverse', 'spin', 'stack-1x', 'stack-2x', 'stack', 'ul', DUOTONE_CLASSES.GROUP, DUOTONE_CLASSES.SWAP_OPACITY, DUOTONE_CLASSES.PRIMARY, DUOTONE_CLASSES.SECONDARY]).concat(oneToTen.map(function (n) {
    return "".concat(n, "x");
  })).concat(oneToTwenty.map(function (n) {
    return "w-".concat(n);
  }));

  function bunker(fn) {
    try {
      for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
        args[_key - 1] = arguments[_key];
      }

      fn.apply(void 0, args);
    } catch (e) {
      if (!PRODUCTION) {
        throw e;
      }
    }
  }

  var w = WINDOW || {};
  if (!w[NAMESPACE_IDENTIFIER]) w[NAMESPACE_IDENTIFIER] = {};
  if (!w[NAMESPACE_IDENTIFIER].styles) w[NAMESPACE_IDENTIFIER].styles = {};
  if (!w[NAMESPACE_IDENTIFIER].hooks) w[NAMESPACE_IDENTIFIER].hooks = {};
  if (!w[NAMESPACE_IDENTIFIER].shims) w[NAMESPACE_IDENTIFIER].shims = [];
  var namespace = w[NAMESPACE_IDENTIFIER];

  function normalizeIcons(icons) {
    return Object.keys(icons).reduce(function (acc, iconName) {
      var icon = icons[iconName];
      var expanded = !!icon.icon;

      if (expanded) {
        acc[icon.iconName] = icon.icon;
      } else {
        acc[iconName] = icon;
      }

      return acc;
    }, {});
  }

  function defineIcons(prefix, icons) {
    var params = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
    var _params$skipHooks = params.skipHooks,
        skipHooks = _params$skipHooks === void 0 ? false : _params$skipHooks;
    var normalized = normalizeIcons(icons);

    if (typeof namespace.hooks.addPack === 'function' && !skipHooks) {
      namespace.hooks.addPack(prefix, normalizeIcons(icons));
    } else {
      namespace.styles[prefix] = _objectSpread2(_objectSpread2({}, namespace.styles[prefix] || {}), normalized);
    }
    /**
     * Font Awesome 4 used the prefix of `fa` for all icons. With the introduction
     * of new styles we needed to differentiate between them. Prefix `fa` is now an alias
     * for `fas` so we'll ease the upgrade process for our users by automatically defining
     * this as well.
     */


    if (prefix === 'fas') {
      defineIcons('fa', icons);
    }
  }

  var icons = {
    
    "passkey": [512,512,[],"e000","M224 32a96 96 0 1 0 0 192 96 96 0 1 0 0-192zM480 224a74.7 74.7 0 1 0 -106.7 67.2V405.3l32 32 53.3-53.3-32-32 32-32-26.5-26.5A74.7 74.7 0 0 0 480 224zm-74.7 0a21.3 21.3 0 1 1 21.3-21.3A21.3 21.3 0 0 1 405.3 224zm-97.3 43.1A128 128 0 0 0 256 256H192A128 128 0 0 0 64 384v42.7H341.3V309.1a110.1 110.1 0 0 1 -33.3-42z"],
    "solid-clipboard-list-check-circle-plus": [576,512,[],"e00e","M0 128C0 92.7 28.7 64 64 64l37.5 0C114.6 26.7 150.2 0 192 0s77.4 26.7 90.5 64L320 64c35.3 0 64 28.7 64 64l0 70.6c-34.9 9.9-65.3 30.2-87.8 57.4L208 256c-8.8 0-16 7.2-16 16s7.2 16 16 16l67.2 0c-10 19.5-16.4 41.1-18.5 64L176 352c-8.8 0-16 7.2-16 16s7.2 16 16 16l80.7 0c4.7 52.4 32.5 98.2 73 127.3c-3.2 .5-6.4 .7-9.8 .7L64 512c-35.3 0-64-28.7-64-64L0 128zM68.7 228.7c-6.2 6.2-6.2 16.4 0 22.6l32 32c6.2 6.2 16.4 6.2 22.6 0l64-64c6.2-6.2 6.2-16.4 0-22.6s-16.4-6.2-22.6 0L112 249.4 91.3 228.7c-6.2-6.2-16.4-6.2-22.6 0zM72 368c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zM160 96c0 17.7 14.3 32 32 32s32-14.3 32-32s-14.3-32-32-32s-32 14.3-32 32zM288 368c0-79.5 64.5-144 144-144s144 64.5 144 144s-64.5 144-144 144s-144-64.5-144-144zm64 0c0 8.8 7.2 16 16 16l48 0 0 48c0 8.8 7.2 16 16 16s16-7.2 16-16l0-48 48 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-48 0 0-48c0-8.8-7.2-16-16-16s-16 7.2-16 16l0 48-48 0c-8.8 0-16 7.2-16 16z"],
    "solid-clipboard-list-check-pen": [576,512,[],"e00f","M0 128C0 92.7 28.7 64 64 64l37.5 0C114.6 26.7 150.2 0 192 0s77.4 26.7 90.5 64L320 64c35.3 0 64 28.7 64 64l0 171.7-64.5 64.5c-1.7-7-8.1-12.2-15.5-12.2l-128 0c-8.8 0-16 7.2-16 16s7.2 16 16 16l123.7 0-10.4 10.4c-8.2 8.2-14 18.5-16.8 29.7l-15.1 60.1c-2.3 9.3-1.8 19 1.4 27.8L64 512c-35.3 0-64-28.7-64-64L0 128zM68.7 228.7c-6.2 6.2-6.2 16.4 0 22.6l32 32c6.2 6.2 16.4 6.2 22.6 0l64-64c6.2-6.2 6.2-16.4 0-22.6s-16.4-6.2-22.6 0L112 249.4 91.3 228.7c-6.2-6.2-16.4-6.2-22.6 0zM72 368c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zM160 96c0 17.7 14.3 32 32 32s32-14.3 32-32s-14.3-32-32-32s-32 14.3-32 32zm32 176c0 8.8 7.2 16 16 16l96 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-96 0c-8.8 0-16 7.2-16 16zm97.5 220.1l15-60.1c1.4-5.7 4.3-10.8 8.4-14.9L442.2 287.9l-.1 0 71 71L383.9 488.1c-4.1 4.1-9.3 7-14.9 8.4l-60.1 15c-5.5 1.4-11.2-.2-15.2-4.2s-5.6-9.7-4.2-15.2zM464.8 265.3l29.4-29.4c15.7-15.6 41-15.6 56.6 0l14.3 14.3c15.6 15.7 15.6 41 0 56.6l-29.4 29.4-70.9-70.9z"],
    "solid-diamond-circle-question": [640,512,[],"e00d","M11.7 227.7l216-216c15.7-15.6 41-15.6 56.6 0C345.2 72.6 406.1 133.5 467 194.4C383.6 208.2 320 280.7 320 368c0 28.1 6.6 54.7 18.3 78.3l-54 54c-15.7 15.6-41 15.6-56.6 0l-216-216c-15.6-15.7-15.6-41 0-56.6zM352 368c0-79.5 64.5-144 144-144s144 64.5 144 144s-64.5 144-144 144s-144-64.5-144-144zm80-46.4l0 6.4c0 8.8 7.2 16 16 16s16-7.2 16-16l0-6.4c0-5.3 4.3-9.6 9.6-9.6l40.5 0c7.7 0 13.9 6.2 13.9 13.9c0 5.2-2.9 9.9-7.4 12.3l-32 16.8c-5.3 2.8-8.6 8.2-8.6 14.2l0 14.8c0 8.8 7.2 16 16 16s16-7.2 16-16l0-5.1 23.5-12.3c15.1-7.9 24.5-23.6 24.5-40.6c0-25.4-20.6-45.9-45.9-45.9l-40.5 0c-23 0-41.6 18.6-41.6 41.6zM472 440c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24z"],
    "solid-house-building-circle-plus": [640,512,[],"e006","M0 277.1c0-13.4 5.6-26.3 15.5-35.4l144-132c18.4-16.8 46.5-16.8 64.9 0l144 132c.9 .8 1.7 1.6 2.5 2.5C339.4 276 320 319.7 320 368c0 49.5 20.5 94.2 53.3 126.2C364.5 505 351.1 512 336 512L48 512c-26.5 0-48-21.5-48-48L0 277.1zM144 296l0 48c0 13.3 10.7 24 24 24l48 0c13.3 0 24-10.7 24-24l0-48c0-13.3-10.7-24-24-24l-48 0c-13.3 0-24 10.7-24 24zM320 48c0-26.5 21.5-48 48-48L592 0c26.5 0 48 21.5 48 48l0 218.8c-16.5-23.3-38.4-42.5-64-55.6l0-3.2c0-8.8-7.2-16-16-16l-32 0c-2.6 0-5.1 .6-7.2 1.7c-8.1-1.1-16.4-1.7-24.8-1.7c-17.6 0-34.5 2.6-50.5 7.4c-2.9-4.4-7.8-7.4-13.5-7.4l-32 0c-8.8 0-16 7.2-16 16l0 4.6-64-58.7L320 48zm32 320c0-79.5 64.5-144 144-144s144 64.5 144 144s-64.5 144-144 144s-144-64.5-144-144zm32-256l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm32 256c0 8.8 7.2 16 16 16l48 0 0 48c0 8.8 7.2 16 16 16s16-7.2 16-16l0-48 48 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-48 0 0-48c0-8.8-7.2-16-16-16s-16 7.2-16 16l0 48-48 0c-8.8 0-16 7.2-16 16zm96-256l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16z"],
    "solid-house-building-pen": [640,512,[],"e007","M0 277.1c0-13.4 5.6-26.3 15.5-35.4l144-132c18.4-16.8 46.5-16.8 64.9 0l144 132c10 9.1 15.6 21.9 15.6 35.4l0 86.6-30.7 30.7c-8.2 8.2-14 18.5-16.8 29.7l-15.1 60.1c-2.3 9.3-1.8 19 1.4 27.8L48 512c-26.5 0-48-21.5-48-48L0 277.1zM144 296l0 48c0 13.3 10.7 24 24 24l48 0c13.3 0 24-10.7 24-24l0-48c0-13.3-10.7-24-24-24l-48 0c-13.3 0-24 10.7-24 24zM320 48c0-26.5 21.5-48 48-48L592 0c26.5 0 48 21.5 48 48l0 168.7-3.6-3.6c-18.5-18.5-44.7-24.8-68.4-18.9c-2.4-1.4-5.1-2.2-8-2.2l-32 0c-8.8 0-16 7.2-16 16l0 27.7-64.5 64.5c-1.7-7-8.1-12.2-15.5-12.2l-16 0 0-10.9c0-7.2-.9-14.3-2.8-21.1l18.8 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16l0 4.6-64-58.7L320 48zm33.5 444.1l15-60.1c1.4-5.7 4.3-10.8 8.4-14.9L506.2 287.9l-.1 0 71 71L447.9 488.1c-4.1 4.1-9.3 7-14.9 8.4l-60.1 15c-5.5 1.4-11.2-.2-15.2-4.2s-5.6-9.7-4.2-15.2zM384 112l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm128 0l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm16.8 153.3l29.4-29.4c15.7-15.6 41-15.6 56.6 0l14.3 14.3c15.6 15.7 15.6 41 0 56.6l-29.4 29.4-70.9-70.9z"],
    "solid-id-badge-slash": [640,512,[],"e003","M5.1 9.2C13.3-1.2 28.4-3.1 38.8 5.1L128 75l0-11c0-35.3 28.7-64 64-64L448 0c35.3 0 64 28.7 64 64l0 312 118.8 93.1c10.4 8.2 12.3 23.3 4.1 33.7s-23.3 12.3-33.7 4.1L9.2 42.9C-1.2 34.7-3.1 19.6 5.1 9.2zM128 196.9L284.4 320.1C241.9 322 208 357 208 400c0 8.8 7.2 16 16 16l182.2 0 91.6 72.2C486 502.7 468.1 512 448 512l-256 0c-35.3 0-64-28.7-64-64l0-251.1zM256 80c0 8.8 7.2 16 16 16l96 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-96 0c-8.8 0-16 7.2-16 16zm12.9 105.5l100.7 78.9C378.8 253.2 384 239 384 224c0-22.9-12.2-44-32-55.4s-44.2-11.4-64 0c-7.6 4.4-14 10.1-19.1 16.9z"],
    "solid-note-circle-plus": [640,512,[],"e00a","M0 96C0 60.7 28.7 32 64 32l320 0c35.3 0 64 28.7 64 64l0 102.6C389.1 215.3 342.7 261.9 326.4 321c-21.9 4.5-38.4 23.8-38.4 47l0 112L64 480c-35.3 0-64-28.7-64-64L0 96zm64 40c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zm0 120c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zm0 120c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zm256-8.1c0 32.2 8.6 62.4 23.7 88.3L320 480l0-45.3c0-22.2 0-44.5 0-66.8zm32 .1c0-79.5 64.5-144 144-144s144 64.5 144 144s-64.5 144-144 144s-144-64.5-144-144zm64 0c0 8.8 7.2 16 16 16l48 0 0 48c0 8.8 7.2 16 16 16s16-7.2 16-16l0-48 48 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-48 0 0-48c0-8.8-7.2-16-16-16s-16 7.2-16 16l0 48-48 0c-8.8 0-16 7.2-16 16z"],
    "solid-note-pen": [640,512,[],"e00b","M0 96C0 60.7 28.7 32 64 32l320 0c35.3 0 64 28.7 64 64l0 203.7L427.7 320 336 320c-26.5 0-48 21.5-48 48l0 112L64 480c-35.3 0-64-28.7-64-64L0 96zm64 40c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zm0 120c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zm0 120c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zm256-8c0-8.8 7.2-16 16-16l59.7 0-42.4 42.4c-8.2 8.2-14 18.5-16.8 29.7l-13.2 52.6L320 480l0-45.3 0-66.7zm33.5 124.1l15-60.1c1.4-5.7 4.3-10.8 8.4-14.9L506.2 287.9l-.1 0 71 71L447.9 488.1c-4.1 4.1-9.3 7-14.9 8.4l-60.1 15c-5.5 1.4-11.2-.2-15.2-4.2s-5.6-9.7-4.2-15.2zM528.8 265.3l29.4-29.4c15.7-15.6 41-15.6 56.6 0l14.3 14.3c15.6 15.7 15.6 41 0 56.6l-29.4 29.4-70.9-70.9z"],
    "solid-note-slash": [640,512,[],"e00c","M5.1 9.2C13.3-1.2 28.4-3.1 38.8 5.1l68.9 54C119.3 42.7 138.4 32 160 32l320 0c35.3 0 64 28.7 64 64l0 224-103.4 0 40.8 32 17.3 0 45.3 0-27.5 27.5 114.3 89.6c10.4 8.2 12.3 23.3 4.1 33.7s-23.3 12.3-33.7 4.1L9.2 42.9C-1.2 34.7-3.1 19.6 5.1 9.2zM96 171.6l78.9 62.2C166.2 237.4 160 246 160 256c0 13.3 10.7 24 24 24c12 0 22-8.8 23.7-20.3L384 398.5l0 81.5-224 0c-35.3 0-64-28.7-64-64l0-244.4zM160 376c0 13.3 10.7 24 24 24s24-10.7 24-24s-10.7-24-24-24s-24 10.7-24 24zm16.7-262.9l31.3 24.5c0-.6 .1-1.1 .1-1.7c0-13.3-10.7-24-24-24c-2.6 0-5 .4-7.3 1.1zM416 423.8l31.5 24.8L416 480l0-45.3 0-10.9z"],
    "solid-truck-pickup-circle-plus": [640,512,[],"e008","M0 320c0-17.7 14.3-32 32-32l0-64c0-17.7 14.3-32 32-32l160 0 0-112c0-26.5 21.5-48 48-48l96.6 0c19.5 0 37.9 8.8 50 24L527.4 192l48.6 0c17.7 0 32 14.3 32 32l0 8.3C577.6 207.1 538.5 192 496 192c-91.8 0-167.2 70.3-175.3 160l-33.8 0c.7 5.2 1.1 10.6 1.1 16c0 61.9-50.1 112-112 112s-112-50.1-112-112c0-5.4 .4-10.8 1.1-16L32 352c-17.7 0-32-14.3-32-32zm128 48c0 17.1 9.1 33 24 41.6s33.1 8.6 48 0s24-24.4 24-41.6s-9.1-33-24-41.6s-33.1-8.6-48 0s-24 24.4-24 41.6zM288 96l0 96 157.4 0L368.6 96 288 96zm64 272c0-79.5 64.5-144 144-144s144 64.5 144 144s-64.5 144-144 144s-144-64.5-144-144zm64 0c0 8.8 7.2 16 16 16l48 0 0 48c0 8.8 7.2 16 16 16s16-7.2 16-16l0-48 48 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-48 0 0-48c0-8.8-7.2-16-16-16s-16 7.2-16 16l0 48-48 0c-8.8 0-16 7.2-16 16z"],
    "solid-truck-pickup-pen": [640,512,[],"e009","M0 320c0-17.7 14.3-32 32-32l0-64c0-17.7 14.3-32 32-32l160 0 0-112c0-26.5 21.5-48 48-48l96.6 0c19.5 0 37.9 8.8 50 24L527.4 192l48.6 0c1.3 0 2.6 .1 3.9 .2c-16.5 1.3-32.7 8.2-45.3 20.9L354.9 392.8c-1.8-8-2.8-16.3-2.8-24.8c0-5.4 .4-10.8 1.1-16l-66.3 0c.7 5.2 1.1 10.6 1.1 16c0 61.9-50.1 112-112 112s-112-50.1-112-112c0-5.4 .4-10.8 1.1-16L32 352c-17.7 0-32-14.3-32-32zm128 48c0 17.1 9.1 33 24 41.6s33.1 8.6 48 0s24-24.4 24-41.6s-9.1-33-24-41.6s-33.1-8.6-48 0s-24 24.4-24 41.6zM288 96l0 96 157.4 0L368.6 96 288 96zm65.5 396.1l15-60.1c1.4-5.7 4.3-10.8 8.4-14.9L506.2 287.9l-.1 0 71 71L447.9 488.1c-4.1 4.1-9.3 7-14.9 8.4l-60.1 15c-5.5 1.4-11.2-.2-15.2-4.2s-5.6-9.7-4.2-15.2zM528.8 265.3l29.4-29.4c15.7-15.6 41-15.6 56.6 0l14.3 14.3c15.6 15.7 15.6 41 0 56.6l-29.4 29.4-70.9-70.9z"],
    "solid-warehouse-circle-check": [640,512,[],"e004","M0 171.3c0-26.2 15.9-49.7 40.2-59.4L308.1 4.8c7.6-3.1 16.1-3.1 23.8 0L599.8 111.9c24.3 9.7 40.2 33.3 40.2 59.4l0 95.5c-26.9-38.1-68.4-65.1-116.4-72.6c-3.6-1.4-7.5-2.2-11.6-2.2l-16 0-368 0c-17.7 0-32 14.3-32 32l0 264c0 13.3-10.7 24-24 24l-48 0c-13.3 0-24-10.7-24-24L0 171.3zM128 224l266.8 0c-28.1 19.8-50.1 47.5-62.8 80l-204 0 0-80zm0 112l194.9 0c-1.9 10.4-2.9 21.1-2.9 32s1 21.6 2.9 32L128 400l0-64zm0 96l204 0c12.7 32.4 34.7 60.2 62.8 80L152 512c-13.3 0-24-10.7-24-24l0-56zm224-64c0-79.5 64.5-144 144-144s144 64.5 144 144s-64.5 144-144 144s-144-64.5-144-144zm76.7-11.3c-6.2 6.2-6.2 16.4 0 22.6l40 40c6.2 6.2 16.4 6.2 22.6 0l72-72c6.2-6.2 6.2-16.4 0-22.6s-16.4-6.2-22.6 0L480 385.4l-28.7-28.7c-6.2-6.2-16.4-6.2-22.6 0z"],
    "solid-warehouse-circle-plus": [640,512,[],"e001","M0 171.3c0-26.2 15.9-49.7 40.2-59.4L308.1 4.8c7.6-3.1 16.1-3.1 23.8 0L599.8 111.9c24.3 9.7 40.2 33.3 40.2 59.4l0 95.5c-26.9-38.1-68.4-65.1-116.4-72.6c-3.6-1.4-7.5-2.2-11.6-2.2l-16 0-368 0c-17.7 0-32 14.3-32 32l0 264c0 13.3-10.7 24-24 24l-48 0c-13.3 0-24-10.7-24-24L0 171.3zM128 224l266.8 0c-28.1 19.8-50.1 47.5-62.8 80l-204 0 0-80zm0 112l194.9 0c-1.9 10.4-2.9 21.1-2.9 32s1 21.6 2.9 32L128 400l0-64zm0 96l204 0c12.7 32.4 34.7 60.2 62.8 80L152 512c-13.3 0-24-10.7-24-24l0-56zm224-64c0-79.5 64.5-144 144-144s144 64.5 144 144s-64.5 144-144 144s-144-64.5-144-144zm64 0c0 8.8 7.2 16 16 16l48 0 0 48c0 8.8 7.2 16 16 16s16-7.2 16-16l0-48 48 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-48 0 0-48c0-8.8-7.2-16-16-16s-16 7.2-16 16l0 48-48 0c-8.8 0-16 7.2-16 16z"],
    "solid-warehouse-gear": [640,512,[],"e002","M0 171.3c0-26.2 15.9-49.7 40.2-59.4L308.1 4.8c7.6-3.1 16.1-3.1 23.8 0L599.8 111.9c24.3 9.7 40.2 33.3 40.2 59.4l0 77.7c-3.4-4.5-7.1-8.7-10.8-12.8c-15.7-16.9-39.5-18.4-57.1-8.8c0-22-14.5-41.9-36.2-46.9c-26.1-5.9-53.5-5.9-79.6 0c-8.3 1.9-15.5 5.9-21.2 11.4l-307 0c-17.7 0-32 14.3-32 32l0 264c0 13.3-10.7 24-24 24l-48 0c-13.3 0-24-10.7-24-24L0 171.3zM128 224l253.6 0c-6.9 2.3-13.3 6.4-18.8 12.3c-18 19.3-31.7 42.6-39.9 67.7L128 304l0-80zm0 112l194.7 0c3.6 10 10.6 18.6 19.4 24.2c-13.1 8.3-22.2 23.3-22.1 39.8l-192 0 0-64zm0 96l200.9 0c8.3 19.1 19.8 36.8 34 52c15.7 16.9 39.6 18.4 57.2 8.8c0 6.6 1.1 13.1 3.7 19.2L152 512c-13.3 0-24-10.7-24-24l0-56zM353 316.1c3.2-10.6 7.7-21 13.5-31s12.6-19.1 20.1-27.2c4.8-5.1 12.4-5.9 18.5-2.4l24.8 14.3c6.9-5.1 14.5-9.5 22.5-12.9l0-30.4c0-7 4.5-13.3 11.3-14.8l0-.1c10.5-2.4 21.5-3.7 32.7-3.7s22.2 1.3 32.7 3.7c6.8 1.5 11.3 7.8 11.3 14.8l0 30.6c8 3.4 15.4 7.7 22.3 12.8l24.9-14.3c6.1-3.5 13.8-2.7 18.4 2.4c7.6 8.1 14.4 17.2 20.1 27.2s10.2 20.4 13.5 31c2 6.7-1.1 13.7-7.2 17.2l-25 14.4c.5 4.1 .7 8.1 .7 12.3s-.3 8.3-.7 12.3l25 14.4c6.1 3.5 9.3 10.5 7.2 17.2c-3.2 10.6-7.7 21-13.5 31s-12.5 19.1-20.1 27.2c-4.8 5.1-12.4 5.9-18.5 2.4l-24.9-14.3c-6.9 5.1-14.4 9.4-22.3 12.8l0 30.6c0 7-4.5 13.3-11.3 14.8c-10.5 2.4-21.5 3.7-32.7 3.7s-22.2-1.3-32.7-3.7c-6.8-1.5-11.3-7.8-11.3-14.8l0-30.5c-8-3.5-15.6-7.8-22.5-12.9l-24.7 14.3c-6 3.5-13.7 2.7-18.5-2.4c-7.6-8.1-14.4-17.2-20.1-27.2s-10.2-20.4-13.5-31c-2-6.7 1.1-13.7 7.2-17.2L385 372.4c-.5-4.1-.7-8.2-.7-12.4s.3-8.3 .7-12.4l-24.8-14.3c-6.1-3.5-9.3-10.5-7.2-17.2zM412 224l8.2 0c-.1 1.2-.1 2.3-.1 3.5c-2.6-1.4-5.3-2.6-8-3.5zm42.9 112c-8.6 14.9-8.6 33.1 0 48s24.4 24 41.6 24s33-9.1 41.6-24s8.6-33.1 0-48s-24.4-24-41.6-24s-33 9.1-41.6 24z"],
    "solid-warehouse-slash": [640,512,[],"e005","M0 171.3c0-21.6 10.8-41.4 28.2-53.1l94.2 74.2C107.4 195.1 96 208.2 96 224l0 264c0 13.3-10.7 24-24 24l-48 0c-13.3 0-24-10.7-24-24L0 171.3zM5.1 9.2C13.3-1.2 28.4-3.1 38.8 5.1l90.7 71.1L308.1 4.8c7.6-3.1 16.1-3.1 23.8 0L599.8 111.9c24.3 9.7 40.2 33.3 40.2 59.4l0 316.3c.1 3.8-.7 7.6-2.5 11.1c-1.3 2.7-3.2 5.1-5.4 7.1c-8.5 7.7-21.6 8.5-31 1.2L9.2 42.9C-1.2 34.7-3.1 19.6 5.1 9.2zM128 224l34.5 0L264 304l-136 0 0-80zm0 112l176.6 0 81.2 64L128 400l0-64zm0 96l298.5 0 83.5 65.8c-3.7 8.4-12.1 14.2-21.9 14.2l-336 0c-13.3 0-24-10.7-24-24l0-56zM277.3 192l40.8 32L512 224l0 80-91.8 0L461 336l51 0 0 40 32 25.1L544 224c0-17.7-14.3-32-32-32l-234.7 0z"]

  };
  var prefixes$1 = [null    ,'fak',
    ,'fa-kit'

  ];
  bunker(function () {
    var _iterator = _createForOfIteratorHelper(prefixes$1),
        _step;

    try {
      for (_iterator.s(); !(_step = _iterator.n()).done;) {
        var prefix = _step.value;
        if (!prefix) continue;
        defineIcons(prefix, icons);
      }
    } catch (err) {
      _iterator.e(err);
    } finally {
      _iterator.f();
    }
  });

}());
