SELECT * FROM user_get (NULL,'ncalle@mail.com','ncalle'); --ok
SELECT * FROM user_get (NULL,'rsanchez@mail.com','rsanchez'); --ok
SELECT * FROM user_get (4,NULL,NULL); --ok
SELECT * FROM user_get (NULL,NULL,NULL); --ok
--------------------------------------------------------------------
SELECT * FROM user_permission_get (1); --ok
SELECT * FROM user_permission_get (NULL); --err ok
SELECT * FROM user_permission_get (12345); --err ok
--------------------------------------------------------------------
SELECT * FROM user_insert ('userInsert1@gmail.com', 'passInsert1', 1, 'Tibursio', 'Gomez', 098898876, 3); --ok
   SELECT * FROM user_get (NULL,'userInsert1@gmail.com','passInsert1'); --ok
SELECT * FROM user_insert (NULL, 'passInsert1', 1, 'Tibursio', 'Gomez', 098898876, 3); --err ok
SELECT * FROM user_insert ('userInsert1@gmail.com', NULL, 1, 'Tibursio', 'Gomez', 098898876, 3); --err ok
SELECT * FROM user_insert ('userInsert1@gmail.com', 'passInsert1', NULL, 'Tibursio', 'Gomez', 098898876, 3); --err ok
SELECT * FROM user_insert ('userInsert1@gmail.com', 'otraPass', 2, 'Otro Tibursio', 'Otro Gomez', 098898876, 3); --err ok
--------------------------------------------------------------------
SELECT * FROM user_delete (10); --ok
   SELECT * FROM user_get (NULL,'userInsert1@gmail.com','passInsert1'); --ok
SELECT * FROM user_delete (1111); --err ok
--------------------------------------------------------------------
SELECT * FROM measurable_object_get (1); --ok
SELECT * FROM measurable_object_get (3); --ok
SELECT * FROM measurable_object_get (null); --ok
   SELECT * FROM prototype_measurable_objects_get (NULL); --ok
   SELECT * FROM prototype_measurable_objects_get (1); --ok
   SELECT * FROM prototype_measurable_objects_get (2); --ok
   SELECT * FROM prototype_measurable_objects_get (3); --ok
--------------------------------------------------------------------
SELECT * FROM prototype_user_measurable_object_to_add_get(1); --ok
SELECT * FROM prototype_user_measurable_object_to_add_get(3); --ok
SELECT * FROM prototype_user_remove_measurable_object(1,85); --ok
SELECT * FROM prototype_user_measurable_object_to_add_get(1); --ok
--------------------------------------------------------------------
SELECT * FROM prototype_user_add_measurable_object(1, 8); --err ok
SELECT * FROM prototype_user_add_measurable_object(1, 85); --ok
SELECT * FROM prototype_user_measurable_object_to_add_get(1); --ok
--------------------------------------------------------------------
SELECT * FROM evaluation_get (1); --ok
SELECT * FROM evaluation_get (NULL); --ok
--------------------------------------------------------------------
SELECT * FROM prototype_measurable_objects_insert (5, 'http://serviciogeografico/Nodo1.2.3/Servicio2.1.2.3', 'WMS', 'Descripcion TESTING', 'Servicio'); --ok
SELECT * FROM measurable_object_get (NULL); --ok
SELECT * FROM measurable_object_get (1); --ok
SELECT * FROM prototype_user_measurable_object_to_add_get(1); --ok
--------------------------------------------------------------------
SELECT * FROM profile_insert ('TestPerfil2', 'Servicio', '1,2,3,4,5,6,7,8,9,10,11,12,43,56,14,231'); --ok
SELECT * FROM profile_insert ('TestPerfil2', NULL, '1,2,3,4,5,6,7,8,9,10,11,12,43,56,14,231'); --err ok
SELECT * FROM profile_insert (NULL, 'Servicio', '1,2,3,4,5,6,7,8,9,10,11,12,43,56,14,231'); --err ok
SELECT * FROM profile_insert ('TestPerfil2', 'Servicio', NULL); --err ok
--------------------------------------------------------------------
SELECT * FROM profile_get (); --ok
--------------------------------------------------------------------
SELECT * FROM user_group_get(null); --ok
SELECT * FROM user_group_get(2); --ok
--------------------------------------------------------------------   
SELECT * FROM institution_get(null); --ok
SELECT * FROM institution_get(2); --ok
--------------------------------------------------------------------   
SELECT * FROM quality_models_get(); --ok
--------------------------------------------------------------------  
SELECT * FROM prototype_measurable_objects_get (null); --ok
SELECT * FROM prototype_measurable_objects_delete(82); --ok
SELECT * FROM prototype_measurable_objects_get (null); --ok
--------------------------------------------------------------------  
SELECT * FROM prototype_measurable_objects_get (null); --ok
SELECT * FROM prototype_measurable_object_update(1, 'http://testing1', 'CSW', 'Testing url description'); --ok
SELECT * FROM prototype_measurable_objects_get (null); --ok
--------------------------------------------------------------------  
SELECT * FROM profile_metric_get(1,null); --ok
SELECT * FROM profile_metric_get(1,1); --ok
SELECT * FROM profile_metric_get(1,2); --ok
SELECT * FROM profile_metric_get(1121,1); --err ok
SELECT * FROM profile_metric_get(null,1); --err ok
--------------------------------------------------------------------  
SELECT * FROM profile_delete(2); --ok
SELECT * FROM profile_delete(null); --err ok
SELECT * FROM profile_delete(67); --err ok
--------------------------------------------------------------------
SELECT * FROM profile_update (1, 'Cambio de Nombre', 'Ide'); --ok
SELECT * FROM profile_get (); --ok
SELECT * FROM profile_update (1, 'Cambio de Nombre', 'otra cosa'); --err ok
SELECT * FROM profile_update (123, 'Cambio de Nombre', 'Ide'); --err ok
--------------------------------------------------------------------
SELECT * FROM profile_remove_metric (1, 2); --ok
SELECT * FROM profile_remove_metric (1, 3); --err ok
SELECT * FROM profile_remove_metric (64, 3); --err ok
SELECT * FROM profile_remove_metric (1, 34533); --err ok
SELECT * FROM profile_metric_get(1,null); --ok
--------------------------------------------------------------------
SELECT * FROM prototype_profile_add_metric (1, 5); --ok
SELECT * FROM profile_metric_get(1,null); --ok
SELECT * FROM prototype_profile_add_metric (2, 5); --err ok
SELECT * FROM prototype_profile_add_metric (1, 54234); --err ok
--------------------------------------------------------------------
SELECT * FROM prototype_profile_metric_to_add_get (1); --ok
--------------------------------------------------------------------
SELECT * FROM metric_get(); --ok
--------------------------------------------------------------------
SELECT * FROM profile_metric_update (5,FALSE,NULL,NULL,NULL); --ok
SELECT * FROM profile_metric_get(3,null); --ok
SELECT * FROM profile_metric_update (223,TRUE,NULL,NULL,NULL); --err ok
--------------------------------------------------------------------
SELECT * FROM evaluation_summary_insert (1, 1, 1, TRUE, 43); --ok
SELECT * FROM evaluation_summary_get (null); --ok
--------------------------------------------------------------------
SELECT * FROM evaluation_insert (1, 2, TRUE); --ok
SELECT * FROM evaluation_get (1); --ok
SELECT * FROM evaluation_insert (1, 7079, TRUE); --err ok
--------------------------------------------------------------------
SELECT * FROM report_geographic_services_per_institution (); --ok
SELECT * FROM report_evaluation_success_vs_failed (); --ok
SELECT * FROM report_evaluations_per_metric (); --ok
SELECT * FROM report_success_evaluation_per_profile (); --ok
SELECT * FROM report_success_evaluation_per_institution (); --ok
SELECT * FROM report_success_evaluation_per_node (); --ok
--------------------------------------------------------------------
SELECT * FROM report_top_best_worst_measurable_object_get (3, TRUE, FALSE); --ok
SELECT * FROM report_top_best_worst_measurable_object_get (3, FALSE, TRUE); --ok
--------------------------------------------------------------------
SELECT * FROM ide_tree_structure_get(null); --ok //UserID
SELECT * FROM ide_tree_structure_get(2); --ok //UserID
SELECT * FROM ide_tree_structure_get(5); --ok //UserID
--------------------------------------------------------------------
SELECT * FROM measurable_object_get (null); --ok
SELECT * FROM services_and_layers_get (null, 'UNASEV', 'Nodo'); --ok
SELECT * FROM services_and_layers_get (null, 'Ministerio de Defensa Nacional', 'Institución'); --ok
SELECT * FROM services_and_layers_get (null, 'ide.uy', 'Ide'); --ok
SELECT * FROM services_and_layers_get (1, 'ide.uy', 'Ide'); --ok
SELECT * FROM services_and_layers_get (10, 'ide.uy', 'Ide'); --ok
--------------------------------------------------------------------
SELECT * FROM quality_weight_tree_sctucture(5); --ok
SELECT * FROM quality_weight_tree_sctucture(55); --err ok