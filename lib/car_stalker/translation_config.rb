# CarStalker translation config.
module CarStalker
  POWER_OPTIONS = ['44 kW (60 AG)', '55 kW (75 AG)', '66 kW (90 AG)',
    '74 kW (100 AG)', '85 kW (116 AG)', '96 kW (130 AG)', '110 kW (150 AG)',
    '147 kW (200 AG)', '184 kW (250 AG)', '223 kW (303 AG)', '263 kW (358 AG)',
    '296 kW (402 AG)', '334 kW (454 AG)']

  TRANSLATION_CONFIG = {
    make:  { autoplius: { field: :make_id_list,
                          options: CarStalker::AUTOPLIUS_MODELS },
             autogidas: { field: :f_1,
                          options: CarStalker::AUTOGIDAS_MODELS } },
    model: { autoplius: { field: :make_id_sublist_portal,
                          options: CarStalker::AUTOPLIUS_MODELS },
             autogidas: { field: :f_model_14,
                          options: CarStalker::AUTOPLIUS_MODELS } },
    engine_capacity_from: { autoplius: { field: :engine_capacity_from,
                                         options: [800..5600] },
                            autogidas: { field: :f_61,
                                         options: [0.8..6.0] } },
    engine_capacity_to:   { autoplius: { field: :engine_capacity_to,
                                         options: [800..5600] },
                            autogidas: { field: :f_62,
                                         options: [0.8..6.0] } },
    power_from: { autoplius: { field:   :power_from,
                               options: CarStalker::POWER_OPTIONS },
                  autogidas: { field:   :f_63,
                               options: CarStalker::POWER_OPTIONS } },
    power_to:   { autoplius: { field:   :power_to,
                               options: CarStalker::POWER_OPTIONS },
                  autogidas: { field:   :f_64,
                               options: CarStalker::POWER_OPTIONS } },
    kilometrage_from: { autoplius: { field: :kilometrage_from,
                                     options: [0..250000] },
                        autogidas: { field: :f_65,
                                     options: [0..250000] } },
    kilometrage_to:   { autoplius: { field: :kilometrage_to,
                                     options: [0..250000] },
                        autogidas: { field: :f_66,
                                     options: [0..250000] } },
    damaged: { autoplius: { field: :has_damaged_id,
                            options: { no: 'No damages',
                                       yes: 'Crashed' } },
               autogidas: { field: :f_46,
                            options: { no: 'Be defektų',
                                       yes: 'Daužtas' } } },
    year_from:  { autoplius: { field:   :make_date_from,
                               options: [1985..Date.today.year] },
                  autogidas: { field:   :f_41,
                               options: [1985..Date.today.year] } },
    year_to:    { autoplius: { field:   :make_date_to,
                               options: [1985..Date.today.year] },
                  autogidas: { field:   :f_42,
                               options: [1985..Date.today.year] } },
    price_from: { autoplius: { field: :sell_price_from,
                               options: [150..60000] },
                  autogidas: { field: :f_215,
                               options: [150..60000] } },
    price_to:   { autoplius: { field: :sell_price_to,
                               options: [150..60000] },
                  autogidas: { field: :f_216,
                               options: [150..60000] } },
    fuel_type:  { autoplius: { field: :fuel_id,
                               options: { diesel: 'Diesel',
                                          petrol: 'Petrol',
                                          petrol_lpg: 'Petrol / LPG',
                                          petrol_ev:  'Petrol / electricity',
                                          ev: 'Electricity',
                                          diesel_ev: 'Diesel / electricity',
                                          other: 'Other' } },
                  autogidas: { field: :f_2,
                               options: { diesel: 'Dyzelinas',
                                          petrol: 'Benzinas',
                                          petrol_lpg: 'Benzinas/Dujos',
                                          petrol_ev:  'Benzinas/Elektra',
                                          ev: 'Elektra',
                                          diesel_ev: 'Dyzelinas/Elektra',
                                          other: 'Kitas' } } },
    gearbox:   { autoplius: { field: :gearbox_id,
                              options: { automatic: 'Automatic',
                                         manual: 'Manual' } },
                 autogidas: { field: :f_10,
                              options: { automatic: 'Automatinė',
                                         manual: 'Mechaninė' } } },
    body_type: { autoplius: { field: :body_type_id,
                              options: { sedan: 'Saloon / sedan',
                                         hatchback: 'Hatchback',
                                         coupe: 'Coupe',
                                         minivan: 'MPV / minivan',
                                         suv: 'SUV / off-road',
                                         wagon: 'Wagon',
                                         convertible: 'Convertible / Roadster',
                                         limousine: 'Limousine',
                                         other: 'Other' } },
                 autogidas: { field: :f_3,
                              options: { sedan: 'Sedanas',
                                         hatchback: 'Hečbekas',
                                         coupe: 'Coupe',
                                         minivan: 'Krovininis mikroautobusas',
                                         suv: 'Visureigis',
                                         wagon: 'Universalas',
                                         convertible: 'Kabrioletas',
                                         limousine: 'Limuzinas',
                                         other: '' } } },
    driven_wheels: { autoplius: { field: :wheel_drive_id,
                                  options: { fwd: 'Front wheel drive (FWD)',
                                             rwd: 'Rear wheel drive (RWD)',
                                             awd: 'All wheel (4x4)' } },
                     autogidas: { field: :f_12,
                                  options: { fwd: 'Priekiniai varantys ratai',
                                             rwd: 'Galiniai varantys ratai',
                                             awd: 'Visi varantys ratai' } } },
    steering_wheel_side: { autoplius: { field: :steering_wheel_id,
                                        options:
                                          { lhd: 'Left hand drive (LHD)',
                                            rhd: 'Right hand drive (RHD)' } },
                           autogidas: { field: :f_265,
                                        options:
                                          { lhd: 'Kairėje',
                                            rhd: 'Dešinėje' } } }
  }.freeze
end
