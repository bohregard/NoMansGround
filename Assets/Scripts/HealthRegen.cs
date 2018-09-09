using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthRegen : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnTriggerEnter(Collider other)
    {
        Debug.Log(other.gameObject.name);
        Health health = other.gameObject.GetComponent<Health>();
        if (health != null)
        {
            health.regen();
        }
        gameObject.SetActive(false);
        StartCoroutine("RegenHealt");
    }

    public IEnumerator RegenHealth()
    {
        yield return new WaitForSeconds(40f);
        gameObject.SetActive(true);
    }
}
