module OfferingFixtures exposing (sample, request)


request : String
request =
    """
    {
        "car_year":"2008",
        "car_id":"320398",
        "postal_code":"1623",
        "state_code":"ar-b",
        "birthdate":"13/10/1985",
        "okm": false,
        "gnc": false
    }
  """



sample : String
sample =
    """
    {
    "id": "44e5248b-9901-43f2-9351-128247c9922f",
    "policy_initial_date": "2018-10-15",
    "renewal_every": 3,
    "package_recomended": "P1",
    "packages": [
        {
            "id": "P1",
            "name": "simple",
            "description": "Terceros completo.",
            "long_description": "",
            "price": 2949.187,
            "products": [
                "LUBRIMOVIL",
                "GROUP_MOBILE_APPLICATION",
                "TOTALES",
                "GROUP_BONUS_FOR_NOT_USING_INSURANCE",
                "TRAVELASSISTANCE",
                "GROUP_BONUS_FOR_PERMANENCE",
                "MECLIG",
                "RUEDAS",
                "GROUP_LEGAL_ADVICE_IN_CASE_OF_ACCIDENTS",
                "RC",
                "GRUA",
                "GROUP_DISCCOUNTS",
                "TAXI",
                "MI",
                "CLEAS",
                "PARCIAL_SIN_RUEDAS"
            ]
        },
        {
            "id": "P2",
            "name": "más",
            "description": "Terceros completo + granizo.",
            "long_description": "",
            "price": 3444.4228,
            "products": [
                "LUBRIMOVIL",
                "DPROBO",
                "GROUP_MOBILE_APPLICATION",
                "CRISTALES",
                "GRANIZO",
                "TOTALES",
                "GROUP_BONUS_FOR_NOT_USING_INSURANCE",
                "TRAVELASSISTANCE",
                "GROUP_BONUS_FOR_PERMANENCE",
                "MECLIG",
                "RUEDAS",
                "GROUP_LEGAL_ADVICE_IN_CASE_OF_ACCIDENTS",
                "RC",
                "INU",
                "CER",
                "GESTORIA",
                "GRUA",
                "GROUP_DISCCOUNTS",
                "TAXI",
                "MI",
                "CLEAS",
                "PARCIAL_SIN_RUEDAS"
            ]
        },
        {
            "id": "P3",
            "name": "full",
            "description": "Todo riesgo.",
            "long_description": "",
            "price": 3444.4228,
            "products": [
                "LUBRIMOVIL",
                "DPROBO",
                "GROUP_MOBILE_APPLICATION",
                "TOTALES",
                "TRAVELASSISTANCE",
                "GROUP_BONUS_FOR_PERMANENCE",
                "MECLIG",
                "GROUP_LEGAL_ADVICE_IN_CASE_OF_ACCIDENTS",
                "INU",
                "PARCIAL",
                "GESTORIA",
                "GRUA",
                "GROUP_DISCCOUNTS",
                "MI",
                "PARCIAL_SIN_RUEDAS",
                "CRISTALES",
                "GRANIZO",
                "GROUP_BONUS_FOR_NOT_USING_INSURANCE",
                "RUEDAS",
                "RC",
                "CER",
                "TAXI",
                "GROUP_EXCESS",
                "CLEAS"
            ]
        }
    ],
    "insurance_amount": "152000",
    "flat_model": "fmod_pricing_039",
    "products": [
        {
            "id": "RC",
            "name": "Responsabilidad Civil",
            "description": "Cubrimos los daños que puedas causar con tu auto a otras personas o sus bienes (casa, auto, negocio, etc.).",
            "type": "coverage"
        },
        {
            "id": "PARCIAL",
            "name": "Daños parciales",
            "description": "Cobertura de todo el valor que supere la franquicia en caso de un daño parcial en el auto. La franquicia es el monto a pagar por el asegurado si tiene contratada la cobertura de Daños Parciales y le ocurra un daño a su auto. Por ejemplo, si el costo del arreglo es de $15.000 y la franquicia es de $8.000, la cobertura es por los $7.000 restantes. Por ello, a mayor franquicia, menor costo por mes (probalo modificando la franquicia para elegir la mejor para vos).",
            "type": "parcial",
            "excesses": [
                {
                    "id": "target_franchise_6500",
                    "value": "6500",
                    "price": 3123.2185
                },
                {
                    "id": "franchise_7000",
                    "value": "7000",
                    "price": 2867.4564
                },
                {
                    "id": "franchise_8000",
                    "value": "8000",
                    "price": 2630.123
                },
                {
                    "id": "franchise_9000",
                    "value": "9000",
                    "price": 2437.1392
                }
            ],
            "excess_recomended": "target_franchise_6500"
        },
        {
            "id": "PARCIAL_SIN_RUEDAS",
            "name": "Robo e incendio parcial",
            "description": "Si roban una parte de tu auto, o se prende fuego parcialmente, lo cubrimos todas las veces que sea necesario.",
            "type": "coverage"
        },
        {
            "id": "RUEDAS",
            "name": "Robo de ruedas",
            "description": "Cubrimos el robo de tus ruedas, las veces que lo necesites.",
            "type": "coverage"
        },
        {
            "id": "TOTALES",
            "name": "Incendio, daños y robo total",
            "description": "Cubrimos la destrucción total de tu auto por daños o incendio, y también estás cubierto si te lo roban o hurtan. Y si te pasa durante el primer año de tu 0 km, te lo reponemos.",
            "type": "coverage"
        },
        {
            "id": "DPROBO",
            "name": "Daño parcial al amparo del robo total",
            "description": "Cobertura de hasta un 10% del valor total del vehículo si es robado y luego se recupera con daños.",
            "type": "extra"
        },
        {
            "id": "MI",
            "name": "Cobertura en accidente",
            "description": "La cobertura de muerte en accidente aplica no sólo al conductor sino también a los ocupantes del vehículo (hasta la cantidad de cinturones de seguridad que traiga originalmente el auto).",
            "type": "coverage"
        },
        {
            "id": "CRISTALES",
            "name": "Cristales",
            "description": "Cobertura de todos los vidrios del auto: cristales laterales, lunetas, parabrisas y el vidrio de techo (cuando corresponda), las veces que sea necesario.",
            "type": "extra"
        },
        {
            "id": "CER",
            "name": "Cerradura",
            "description": "Reemplazo e instalación de la cerradura si es forzada o rota durante un accidente, las veces que sea necesario .",
            "type": "extra"
        },
        {
            "id": "GRANIZO",
            "name": "Granizo",
            "description": "Cobertura en caso de que el auto sea afectado por el granizo, sin límites por cantidad de bollos.",
            "type": "extra"
        },
        {
            "id": "INU",
            "name": "Daños parciales por inundación",
            "description": "Cobertura de hasta el 15% del valor del vehículo en caso de que se inunde y haya que repararlo.",
            "type": "extra"
        },
        {
            "id": "GROUP_BONUS_FOR_NOT_USING_INSURANCE",
            "name": "Bonificación por no usar el seguro",
            "description": "Si no usás el seguro, te bonificamos el equivalente a 1 cuota al renovar tu póliza el primer año; 2 cuotas el segundo y 3 cuotas el tercero. Te mantenemos el beneficio si alguien te choca y no sos el responsable.",
            "type": "service"
        },
        {
            "id": "GROUP_BONUS_FOR_PERMANENCE",
            "name": "Bonificación por permanencia",
            "description": "Anualmente, al renovar tu póliza, te bonificamos media cuota el primer año, 1 cuota el segundo año, 1 cuota y media el tercero y hasta 2 cuotas el cuarto año.",
            "type": "service"
        },
        {
            "id": "GRUA",
            "name": "Grúas en menos de 90 minutos, ilimitadas",
            "description": "Si necesitás una grúa te remolcamos todas las veces que sea necesario. En CABA y Gran Buenos Aires lo hacemos en menos de 90 minutos.",
            "type": "service"
        },
        {
            "id": "MECLIG",
            "name": "Mecánica ligera con moto en menos de 30 minutos, ilimitada",
            "description": "Si estás en CABA y necesitás ayuda para cambiar una rueda o revisar la batería, te enviamos una moto en menos de 30 minutos.",
            "type": "service"
        },
        {
            "id": "GROUP_LEGAL_ADVICE_IN_CASE_OF_ACCIDENTS",
            "name": "Asesoramiento legal en caso de accidente",
            "description": "Te brindamos asesoramiento legal ante un accidente de tránsito con tu auto.",
            "type": "service"
        },
        {
            "id": "CLEAS",
            "name": "Atención propia si te chocan de otras compañías seleccionadas",
            "description": "Si tenés un choque con un cliente de las aseguradoras miembro de CLEAS (Allianz, La Segunda, Mapfre, RUS, Sancor, San Cristóbal, Rivadavia, Sura, Zurich) y no sos el responsable, resolvés todo de manera directa con nosotros evitando trámites con otras aseguradoras.",
            "type": "service"
        },
        {
            "id": "TAXI",
            "name": "Taxi o remís para tus acompañantes",
            "description": "Si es necesario remolcar tu auto y tenés acompañantes, te enviamos un taxi o remís para ellos (por ley sólo puede viajar 1 persona con la grúa).",
            "type": "service"
        },
        {
            "id": "TRAVELASSISTANCE",
            "name": "Asistencia al viajero",
            "description": "Si tenés un problema mecánico a más de 100 km de tu casa registrada, podemos darte un auto sustituto, pagar un alojamiento temporario, el traslado, un conductor profesional (si no podés manejar) y la posible asistencia médica inmediata.",
            "type": "service"
        },
        {
            "id": "LUBRIMOVIL",
            "name": "Lubrimóvil",
            "description": "El lubrimóvil te hace el cambio de aceite a domicilio cuando lo necesites (el costo de los insumos no está incluido).",
            "type": "service"
        },
        {
            "id": "GROUP_DISCCOUNTS",
            "name": "Descuentos en servicios vinculados a tu auto",
            "description": "Cuando necesites algún servicio para tu auto, contactanos. Te podemos conseguir descuentos y hasta servicios gratis en nuestra red de talleres especializados.",
            "type": "service"
        },
        {
            "id": "GROUP_MOBILE_APPLICATION",
            "name": "App para autogestionar servicios",
            "description": "Todo lo que necesites, desde pedir una asistencia hasta denunciar un siniestro, lo podés hacer desde nuestra App.",
            "type": "service"
        },
        {
            "id": "GESTORIA",
            "name": "Reintegro de gastos de gestoría",
            "description": "Cobertura del 100% del valor que sea necesario del vehículo en caso de que haya que darlo de baja (o por cualquier otro gasto de gestoría relacionado con el robo o destrucción total).",
            "type": "extra"
        },
        {
            "id": "GROUP_EXCESS",
            "name": "Financiación de la franquicia",
            "description": "En caso de que sea necesario pagar la franquicia, podemos financiártela a través de una compañía de nuestro grupo.",
            "type": "parcial"
        }
    ]
}
  """
