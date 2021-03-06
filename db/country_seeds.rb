puts 'Seeding Countries'
countries = [
  {name: 'Afghanistan', alpha_2: 'af', alpha_3: 'afg'},
  {name: 'Aland Islands', alpha_2: 'ax', alpha_3: 'ala'},
  {name: 'Albania', alpha_2: 'al', alpha_3: 'alb'},
  {name: 'Algeria', alpha_2: 'dz', alpha_3: 'dza'},
  {name: 'American Samoa', alpha_2: 'as', alpha_3: 'asm'},
  {name: 'Andorra', alpha_2: 'ad', alpha_3: 'and'},
  {name: 'Angola', alpha_2: 'ao', alpha_3: 'ago'},
  {name: 'Anguilla', alpha_2: 'ai', alpha_3: 'aia'},
  {name: 'Antarctica', alpha_2: 'aq', alpha_3: ''},
  {name: 'Antigua and Barbuda', alpha_2: 'ag', alpha_3: 'atg'},
  {name: 'Argentina', alpha_2: 'ar', alpha_3: 'arg'},
  {name: 'Armenia', alpha_2: 'am', alpha_3: 'arm'},
  {name: 'Aruba', alpha_2: 'aw', alpha_3: 'abw'},
  {name: 'Australia', alpha_2: 'au', alpha_3: 'aus'},
  {name: 'Austria', alpha_2: 'at', alpha_3: 'aut'},
  {name: 'Azerbaijan', alpha_2: 'az', alpha_3: 'aze'},
  {name: 'Bahamas', alpha_2: 'bs', alpha_3: 'bhs'},
  {name: 'Bahrain', alpha_2: 'bh', alpha_3: 'bhr'},
  {name: 'Bangladesh', alpha_2: 'bd', alpha_3: 'bgd'},
  {name: 'Barbados', alpha_2: 'bb', alpha_3: 'brb'},
  {name: 'Belarus', alpha_2: 'by', alpha_3: 'blr'},
  {name: 'Belgium', alpha_2: 'be', alpha_3: 'bel'},
  {name: 'Belize', alpha_2: 'bz', alpha_3: 'blz'},
  {name: 'Benin', alpha_2: 'bj', alpha_3: 'ben'},
  {name: 'Bermuda', alpha_2: 'bm', alpha_3: 'bmu'},
  {name: 'Bhutan', alpha_2: 'bt', alpha_3: 'btn'},
  {name: 'Bolivia, Plurinational State of', alpha_2: 'bo', alpha_3: 'bol'},
  {name: 'Bonaire, Sint Eustatius and Saba', alpha_2: 'bq', alpha_3: 'bes'},
  {name: 'Bosnia and Herzegovina', alpha_2: 'ba', alpha_3: 'bih'},
  {name: 'Botswana', alpha_2: 'bw', alpha_3: 'bwa'},
  {name: 'Bouvet Island', alpha_2: 'bv', alpha_3: ''},
  {name: 'Brazil', alpha_2: 'br', alpha_3: 'bra'},
  {name: 'British Indian Ocean Territory', alpha_2: 'io', alpha_3: ''},
  {name: 'Brunei Darussalam', alpha_2: 'bn', alpha_3: 'brn'},
  {name: 'Bulgaria', alpha_2: 'bg', alpha_3: 'bgr'},
  {name: 'Burkina Faso', alpha_2: 'bf', alpha_3: 'bfa'},
  {name: 'Burundi', alpha_2: 'bi', alpha_3: 'bdi'},
  {name: 'Cambodia', alpha_2: 'kh', alpha_3: 'khm'},
  {name: 'Cameroon', alpha_2: 'cm', alpha_3: 'cmr'},
  {name: 'Canada', alpha_2: 'ca', alpha_3: 'can'},
  {name: 'Cape Verde', alpha_2: 'cv', alpha_3: 'cpv'},
  {name: 'Cayman Islands', alpha_2: 'ky', alpha_3: 'cym'},
  {name: 'Central African Republic', alpha_2: 'cf', alpha_3: 'caf'},
  {name: 'Chad', alpha_2: 'td', alpha_3: 'tcd'},
  {name: 'Chile', alpha_2: 'cl', alpha_3: 'chl'},
  {name: 'China', alpha_2: 'cn', alpha_3: 'chn'},
  {name: 'Christmas Island', alpha_2: 'cx', alpha_3: ''},
  {name: 'Cocos (Keeling) Islands', alpha_2: 'cc', alpha_3: ''},
  {name: 'Colombia', alpha_2: 'co', alpha_3: 'col'},
  {name: 'Comoros', alpha_2: 'km', alpha_3: 'com'},
  {name: 'Congo', alpha_2: 'cg', alpha_3: 'cog'},
  {name: 'Congo, The Democratic Republic of the', alpha_2: 'cd', alpha_3: 'cod'},
  {name: 'Cook Islands', alpha_2: 'ck', alpha_3: 'cok'},
  {name: 'Costa Rica', alpha_2: 'cr', alpha_3: 'cri'},
  {name: 'Cote d\'Ivoire', alpha_2: 'ci', alpha_3: 'civ'},
  {name: 'Croatia', alpha_2: 'hr', alpha_3: 'hrv'},
  {name: 'Cuba', alpha_2: 'cu', alpha_3: 'cub'},
  {name: 'Curacao', alpha_2: 'cw', alpha_3: 'cuw'},
  {name: 'Cyprus', alpha_2: 'cy', alpha_3: 'cyp'},
  {name: 'Czech Republic', alpha_2: 'cz', alpha_3: 'cze'},
  {name: 'Denmark', alpha_2: 'dk', alpha_3: 'dnk'},
  {name: 'Djibouti', alpha_2: 'dj', alpha_3: 'dji'},
  {name: 'Dominica', alpha_2: 'dm', alpha_3: 'dma'},
  {name: 'Dominican Republic', alpha_2: 'do', alpha_3: 'dom'},
  {name: 'Ecuador', alpha_2: 'ec', alpha_3: 'ecu'},
  {name: 'Egypt', alpha_2: 'eg', alpha_3: 'egy'},
  {name: 'El Salvador', alpha_2: 'sv', alpha_3: 'slv'},
  {name: 'Equatorial Guinea', alpha_2: 'gq', alpha_3: 'gnq'},
  {name: 'Eritrea', alpha_2: 'er', alpha_3: 'eri'},
  {name: 'Estonia', alpha_2: 'ee', alpha_3: 'est'},
  {name: 'Ethiopia', alpha_2: 'et', alpha_3: 'eth'},
  {name: 'Falkland Islands (Malvinas)', alpha_2: 'fk', alpha_3: 'flk'},
  {name: 'Faroe Islands', alpha_2: 'fo', alpha_3: 'fro'},
  {name: 'Fiji', alpha_2: 'fj', alpha_3: 'fji'},
  {name: 'Finland', alpha_2: 'fi', alpha_3: 'fin'},
  {name: 'France', alpha_2: 'fr', alpha_3: 'fra'},
  {name: 'French Guiana', alpha_2: 'gf', alpha_3: 'guf'},
  {name: 'French Polynesia', alpha_2: 'pf', alpha_3: 'pyf'},
  {name: 'French Southern Territories', alpha_2: 'tf', alpha_3: ''},
  {name: 'Gabon', alpha_2: 'ga', alpha_3: 'gab'},
  {name: 'Gambia', alpha_2: 'gm', alpha_3: 'gmb'},
  {name: 'Georgia', alpha_2: 'ge', alpha_3: 'geo'},
  {name: 'Germany', alpha_2: 'de', alpha_3: 'deu'},
  {name: 'Ghana', alpha_2: 'gh', alpha_3: 'gha'},
  {name: 'Gibraltar', alpha_2: 'gi', alpha_3: 'gib'},
  {name: 'Greece', alpha_2: 'gr', alpha_3: 'grc'},
  {name: 'Greenland', alpha_2: 'gl', alpha_3: 'grl'},
  {name: 'Grenada', alpha_2: 'gd', alpha_3: 'grd'},
  {name: 'Guadeloupe', alpha_2: 'gp', alpha_3: 'glp'},
  {name: 'Guam', alpha_2: 'gu', alpha_3: 'gum'},
  {name: 'Guatemala', alpha_2: 'gt', alpha_3: 'gtm'},
  {name: 'Guernsey', alpha_2: 'gg', alpha_3: 'ggy'},
  {name: 'Guinea', alpha_2: 'gn', alpha_3: 'gin'},
  {name: 'Guinea-Bissau', alpha_2: 'gw', alpha_3: 'gnb'},
  {name: 'Guyana', alpha_2: 'gy', alpha_3: 'guy'},
  {name: 'Haiti', alpha_2: 'ht', alpha_3: 'hti'},
  {name: 'Heard Island and McDonald Islands', alpha_2: 'hm', alpha_3: ''},
  {name: 'Holy See (Vatican City State)', alpha_2: 'va', alpha_3: 'vat'},
  {name: 'Honduras', alpha_2: 'hn', alpha_3: 'hnd'},
  {name: 'Hong Kong', alpha_2: 'hk', alpha_3: 'hkg'},
  {name: 'Hungary', alpha_2: 'hu', alpha_3: 'hun'},
  {name: 'Iceland', alpha_2: 'is', alpha_3: 'isl'},
  {name: 'India', alpha_2: 'in', alpha_3: 'ind'},
  {name: 'Indonesia', alpha_2: 'id', alpha_3: 'idn'},
  {name: 'Iran, Islamic Republic of', alpha_2: 'ir', alpha_3: 'irn'},
  {name: 'Iraq', alpha_2: 'iq', alpha_3: 'irq'},
  {name: 'Ireland', alpha_2: 'ie', alpha_3: 'irl'},
  {name: 'Isle of Man', alpha_2: 'im', alpha_3: 'imn'},
  {name: 'Israel', alpha_2: 'il', alpha_3: 'isr'},
  {name: 'Italy', alpha_2: 'it', alpha_3: 'ita'},
  {name: 'Jamaica', alpha_2: 'jm', alpha_3: 'jam'},
  {name: 'Japan', alpha_2: 'jp', alpha_3: 'jpn'},
  {name: 'Jersey', alpha_2: 'je', alpha_3: 'jey'},
  {name: 'Jordan', alpha_2: 'jo', alpha_3: 'jor'},
  {name: 'Kazakhstan', alpha_2: 'kz', alpha_3: 'kaz'},
  {name: 'Kenya', alpha_2: 'ke', alpha_3: 'ken'},
  {name: 'Kiribati', alpha_2: 'ki', alpha_3: 'kir'},
  {name: 'Korea, Democratic People\'s Republic of', alpha_2: 'kp', alpha_3: 'prk'},
  {name: 'Korea, Republic of', alpha_2: 'kr', alpha_3: 'kor'},
  {name: 'Kuwait', alpha_2: 'kw', alpha_3: 'kwt'},
  {name: 'Kyrgyzstan', alpha_2: 'kg', alpha_3: 'kgz'},
  {name: 'Lao People\'s Democratic Republic', alpha_2: 'la', alpha_3: 'lao'},
  {name: 'Latvia', alpha_2: 'lv', alpha_3: 'lva'},
  {name: 'Lebanon', alpha_2: 'lb', alpha_3: 'lbn'},
  {name: 'Lesotho', alpha_2: 'ls', alpha_3: 'lso'},
  {name: 'Liberia', alpha_2: 'lr', alpha_3: 'lbr'},
  {name: 'Libyan Arab Jamahiriya', alpha_2: 'ly', alpha_3: 'lby'},
  {name: 'Liechtenstein', alpha_2: 'li', alpha_3: 'lie'},
  {name: 'Lithuania', alpha_2: 'lt', alpha_3: 'ltu'},
  {name: 'Luxembourg', alpha_2: 'lu', alpha_3: 'lux'},
  {name: 'Macao', alpha_2: 'mo', alpha_3: 'mac'},
  {name: 'Macedonia, The former Yugoslav Republic of', alpha_2: 'mk', alpha_3: 'mkd'},
  {name: 'Madagascar', alpha_2: 'mg', alpha_3: 'mdg'},
  {name: 'Malawi', alpha_2: 'mw', alpha_3: 'mwi'},
  {name: 'Malaysia', alpha_2: 'my', alpha_3: 'mys'},
  {name: 'Maldives', alpha_2: 'mv', alpha_3: 'mdv'},
  {name: 'Mali', alpha_2: 'ml', alpha_3: 'mli'},
  {name: 'Malta', alpha_2: 'mt', alpha_3: 'mlt'},
  {name: 'Marshall Islands', alpha_2: 'mh', alpha_3: 'mhl'},
  {name: 'Martinique', alpha_2: 'mq', alpha_3: 'mtq'},
  {name: 'Mauritania', alpha_2: 'mr', alpha_3: 'mrt'},
  {name: 'Mauritius', alpha_2: 'mu', alpha_3: 'mus'},
  {name: 'Mayotte', alpha_2: 'yt', alpha_3: 'myt'},
  {name: 'Mexico', alpha_2: 'mx', alpha_3: 'mex'},
  {name: 'Micronesia, Federated States of', alpha_2: 'fm', alpha_3: 'fsm'},
  {name: 'Moldova, Republic of', alpha_2: 'md', alpha_3: 'mda'},
  {name: 'Monaco', alpha_2: 'mc', alpha_3: 'mco'},
  {name: 'Mongolia', alpha_2: 'mn', alpha_3: 'mng'},
  {name: 'Montenegro', alpha_2: 'me', alpha_3: 'mne'},
  {name: 'Montserrat', alpha_2: 'ms', alpha_3: 'msr'},
  {name: 'Morocco', alpha_2: 'ma', alpha_3: 'mar'},
  {name: 'Mozambique', alpha_2: 'mz', alpha_3: 'moz'},
  {name: 'Myanmar', alpha_2: 'mm', alpha_3: 'mmr'},
  {name: 'Namibia', alpha_2: 'na', alpha_3: 'nam'},
  {name: 'Nauru', alpha_2: 'nr', alpha_3: 'nru'},
  {name: 'Nepal', alpha_2: 'np', alpha_3: 'npl'},
  {name: 'Netherlands', alpha_2: 'nl', alpha_3: 'nld'},
  {name: 'New Caledonia', alpha_2: 'nc', alpha_3: 'ncl'},
  {name: 'New Zealand', alpha_2: 'nz', alpha_3: 'nzl'},
  {name: 'Nicaragua', alpha_2: 'ni', alpha_3: 'nic'},
  {name: 'Niger', alpha_2: 'ne', alpha_3: 'ner'},
  {name: 'Nigeria', alpha_2: 'ng', alpha_3: 'nga'},
  {name: 'Niue', alpha_2: 'nu', alpha_3: 'niu'},
  {name: 'Norfolk Island', alpha_2: 'nf', alpha_3: 'nfk'},
  {name: 'Northern Mariana Islands', alpha_2: 'mp', alpha_3: 'mnp'},
  {name: 'Norway', alpha_2: 'no', alpha_3: 'nor'},
  {name: 'Oman', alpha_2: 'om', alpha_3: 'omn'},
  {name: 'Pakistan', alpha_2: 'pk', alpha_3: 'pak'},
  {name: 'Palau', alpha_2: 'pw', alpha_3: 'plw'},
  {name: 'Palestinian Territory, Occupied', alpha_2: 'ps', alpha_3: 'pse'},
  {name: 'Panama', alpha_2: 'pa', alpha_3: 'pan'},
  {name: 'Papua New Guinea', alpha_2: 'pg', alpha_3: 'png'},
  {name: 'Paraguay', alpha_2: 'py', alpha_3: 'pry'},
  {name: 'Peru', alpha_2: 'pe', alpha_3: 'per'},
  {name: 'Philippines', alpha_2: 'ph', alpha_3: 'phl'},
  {name: 'Pitcairn', alpha_2: 'pn', alpha_3: 'pcn'},
  {name: 'Poland', alpha_2: 'pl', alpha_3: 'pol'},
  {name: 'Portugal', alpha_2: 'pt', alpha_3: 'prt'},
  {name: 'Puerto Rico', alpha_2: 'pr', alpha_3: 'pri'},
  {name: 'Qatar', alpha_2: 'qa', alpha_3: 'qat'},
  {name: 'Reunion', alpha_2: 're', alpha_3: 'reu'},
  {name: 'Romania', alpha_2: 'ro', alpha_3: 'rou'},
  {name: 'Russian Federation', alpha_2: 'ru', alpha_3: 'rus'},
  {name: 'Rwanda', alpha_2: 'rw', alpha_3: 'rwa'},
  {name: 'Saint Barthelemy', alpha_2: 'bl', alpha_3: 'blm'},
  {name: 'Saint Helena, Ascension and Tristan Da Cunha', alpha_2: 'sh', alpha_3: 'shn'},
  {name: 'Saint Kitts and Nevis', alpha_2: 'kn', alpha_3: 'kna'},
  {name: 'Saint Lucia', alpha_2: 'lc', alpha_3: 'lca'},
  {name: 'Saint Martin (French Part)', alpha_2: 'mf', alpha_3: 'maf'},
  {name: 'Saint Pierre and Miquelon', alpha_2: 'pm', alpha_3: 'spm'},
  {name: 'Saint Vincent and The Grenadines', alpha_2: 'vc', alpha_3: 'vct'},
  {name: 'Samoa', alpha_2: 'ws', alpha_3: 'wsm'},
  {name: 'San Marino', alpha_2: 'sm', alpha_3: 'smr'},
  {name: 'Sao Tome and Principe', alpha_2: 'st', alpha_3: 'stp'},
  {name: 'Saudi Arabia', alpha_2: 'sa', alpha_3: 'sau'},
  {name: 'Senegal', alpha_2: 'sn', alpha_3: 'sen'},
  {name: 'Serbia', alpha_2: 'rs', alpha_3: 'srb'},
  {name: 'Seychelles', alpha_2: 'sc', alpha_3: 'syc'},
  {name: 'Sierra Leone', alpha_2: 'sl', alpha_3: 'sle'},
  {name: 'Singapore', alpha_2: 'sg', alpha_3: 'sgp'},
  {name: 'Sint Maarten (Dutch Part)', alpha_2: 'sx', alpha_3: 'sxm'},
  {name: 'Slovakia', alpha_2: 'sk', alpha_3: 'svk'},
  {name: 'Slovenia', alpha_2: 'si', alpha_3: 'svn'},
  {name: 'Solomon Islands', alpha_2: 'sb', alpha_3: 'slb'},
  {name: 'Somalia', alpha_2: 'so', alpha_3: 'som'},
  {name: 'South Africa', alpha_2: 'za', alpha_3: 'zaf'},
  {name: 'South Georgia and The South Sandwich Islands', alpha_2: 'gs', alpha_3: ''},
  {name: 'South Sudan', alpha_2: 'ss', alpha_3: 'ssd'},
  {name: 'Spain', alpha_2: 'es', alpha_3: 'esp'},
  {name: 'Sri Lanka', alpha_2: 'lk', alpha_3: 'lka'},
  {name: 'Sudan', alpha_2: 'sd', alpha_3: 'sdn'},
  {name: 'Suriname', alpha_2: 'sr', alpha_3: 'sur'},
  {name: 'Svalbard and Jan Mayen', alpha_2: 'sj', alpha_3: 'sjm'},
  {name: 'Swaziland', alpha_2: 'sz', alpha_3: 'swz'},
  {name: 'Sweden', alpha_2: 'se', alpha_3: 'swe'},
  {name: 'Switzerland', alpha_2: 'ch', alpha_3: 'che'},
  {name: 'Syrian Arab Republic', alpha_2: 'sy', alpha_3: 'syr'},
  {name: 'Taiwan, Province of China', alpha_2: 'tw', alpha_3: ''},
  {name: 'Tajikistan', alpha_2: 'tj', alpha_3: 'tjk'},
  {name: 'Tanzania, United Republic of', alpha_2: 'tz', alpha_3: 'tza'},
  {name: 'Thailand', alpha_2: 'th', alpha_3: 'tha'},
  {name: 'Timor-Leste', alpha_2: 'tl', alpha_3: 'tls'},
  {name: 'Togo', alpha_2: 'tg', alpha_3: 'tgo'},
  {name: 'Tokelau', alpha_2: 'tk', alpha_3: 'tkl'},
  {name: 'Tonga', alpha_2: 'to', alpha_3: 'ton'},
  {name: 'Trinidad and Tobago', alpha_2: 'tt', alpha_3: 'tto'},
  {name: 'Tunisia', alpha_2: 'tn', alpha_3: 'tun'},
  {name: 'Turkey', alpha_2: 'tr', alpha_3: 'tur'},
  {name: 'Turkmenistan', alpha_2: 'tm', alpha_3: 'tkm'},
  {name: 'Turks and Caicos Islands', alpha_2: 'tc', alpha_3: 'tca'},
  {name: 'Tuvalu', alpha_2: 'tv', alpha_3: 'tuv'},
  {name: 'Uganda', alpha_2: 'ug', alpha_3: 'uga'},
  {name: 'Ukraine', alpha_2: 'ua', alpha_3: 'ukr'},
  {name: 'United Arab Emirates', alpha_2: 'ae', alpha_3: 'are'},
  {name: 'United Kingdom', alpha_2: 'gb', alpha_3: 'gbr'},
  {name: 'United States', alpha_2: 'us', alpha_3: 'usa'},
  {name: 'United States Minor Outlying Islands', alpha_2: 'um', alpha_3: ''},
  {name: 'Uruguay', alpha_2: 'uy', alpha_3: 'ury'},
  {name: 'Uzbekistan', alpha_2: 'uz', alpha_3: 'uzb'},
  {name: 'Vanuatu', alpha_2: 'vu', alpha_3: 'vut'},
  {name: 'Venezuela, Bolivarian Republic of', alpha_2: 've', alpha_3: 'ven'},
  {name: 'Viet Nam', alpha_2: 'vn', alpha_3: 'vnm'},
  {name: 'Virgin Islands, British', alpha_2: 'vg', alpha_3: 'vgb'},
  {name: 'Virgin Islands, U.S.', alpha_2: 'vi', alpha_3: 'vir'},
  {name: 'Wallis and Futuna', alpha_2: 'wf', alpha_3: 'wlf'},
  {name: 'Western Sahara', alpha_2: 'eh', alpha_3: 'esh'},
  {name: 'Yemen', alpha_2: 'ye', alpha_3: 'yem'},
  {name: 'Zambia', alpha_2: 'zm', alpha_3: 'zmb'},
  {name: 'Zimbabwe', alpha_2: 'zw', alpha_3: 'zwe'}
]

countries.each do |country_raw|
  Country.find_or_create_by(country_raw)
end
puts "Created #{countries.count} countries"
