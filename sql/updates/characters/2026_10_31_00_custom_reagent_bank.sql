-- characters: custom_reagent_bank for Ling
CREATE TABLE IF NOT EXISTS `custom_reagent_bank` (
  `character_id` int(10) unsigned NOT NULL,
  `item_entry` int(10) unsigned NOT NULL,
  `amount` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`character_id`,`item_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
